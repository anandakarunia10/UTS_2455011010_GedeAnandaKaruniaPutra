import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/my_plant_model.dart';
import '../providers/my_plant_provider.dart';

class EditPlantScreen extends StatefulWidget {
  final MyPlantModel plant;

  const EditPlantScreen({
    super.key,
    required this.plant,
  });

  @override
  State<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _scheduleController;
  late TextEditingController _dateController;
  late TextEditingController _imageUrlController;
  late TextEditingController _notesController;

  late String _healthStatus;
  bool _isLoading = false;

  final List<String> _statusOptions = [
    'Healthy',
    'Needs Water',
    'Sick',
    'Recovering',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.plantName);
    _scheduleController = TextEditingController(text: widget.plant.waterSchedule);
    _dateController = TextEditingController(text: widget.plant.lastWateredDate);
    _imageUrlController = TextEditingController(text: widget.plant.imageUrl);
    _notesController = TextEditingController(text: widget.plant.notes);

    _healthStatus = _statusOptions.contains(widget.plant.healthStatus)
        ? widget.plant.healthStatus
        : 'Healthy';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scheduleController.dispose();
    _dateController.dispose();
    _imageUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF88B04B),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedPlant = MyPlantModel(
        studentId: widget.plant.studentId,
        plantId: widget.plant.plantId,
        plantName: _nameController.text.trim(),
        waterSchedule: _scheduleController.text.trim(),
        lastWateredDate: _dateController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        healthStatus: _healthStatus,
        notes: _notesController.text.trim(),
      );

      final provider = Provider.of<MyPlantProvider>(context, listen: false);
      await provider.updatePlant(updatedPlant.plantId.toString(), updatedPlant.toJson());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data tanaman berhasil diperbarui!'),
            backgroundColor: const Color(0xFF88B04B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui data: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF88B04B);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F2),
      appBar: AppBar(
        title: const Text(
          'Edit Tanaman',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFFF4F6F2),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Tanaman',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nama Tanaman
                    _buildTextField(
                      controller: _nameController,
                      label: 'Nama Tanaman',
                      icon: Icons.local_florist_rounded,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama tanaman tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Jadwal Penyiraman
                    _buildTextField(
                      controller: _scheduleController,
                      label: 'Jadwal Penyiraman',
                      icon: Icons.water_drop_rounded,
                      hint: 'Contoh: Setiap 2 Hari',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Jadwal penyiraman tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Tanggal Terakhir Disiram
                    _buildTextField(
                      controller: _dateController,
                      label: 'Tanggal Terakhir Disiram',
                      icon: Icons.calendar_today_rounded,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Pilih tanggal terakhir disiram';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Status Kesehatan Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: _healthStatus,
                      decoration: _getInputDecoration(
                        label: 'Status Kesehatan',
                        icon: Icons.health_and_safety_rounded,
                      ),
                      items: _statusOptions.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _healthStatus = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // URL Gambar
                    _buildTextField(
                      controller: _imageUrlController,
                      label: 'URL Gambar',
                      icon: Icons.image_rounded,
                      hint: 'https://example.com/image.jpg',
                    ),
                    const SizedBox(height: 16),

                    // Catatan
                    _buildTextField(
                      controller: _notesController,
                      label: 'Catatan (Opsional)',
                      icon: Icons.note_alt_rounded,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan Perubahan
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitForm,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_circle_rounded, size: 22),
                  label: Text(
                    _isLoading ? 'Menyimpan...' : 'Simpan Perubahan',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool readOnly = false,
    int maxLines = 1,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: _getInputDecoration(
        label: label,
        icon: icon,
        hint: hint,
      ),
    );
  }

  InputDecoration _getInputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    const primaryGreen = Color(0xFF88B04B);

    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
      prefixIcon: Icon(icon, size: 20, color: primaryGreen),
      filled: true,
      fillColor: const Color(0xFFF9FBF8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 0.8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryGreen, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade400, width: 0.8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade600, width: 1.5),
      ),
    );
  }
}