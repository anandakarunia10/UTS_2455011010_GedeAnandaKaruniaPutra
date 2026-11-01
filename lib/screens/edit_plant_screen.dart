
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

  late TextEditingController _scheduleController;
  late TextEditingController _notesController;

  late String _healthStatus;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _scheduleController = TextEditingController(
      text: widget.plant.waterSchedule,
    );

    _notesController = TextEditingController(
      text: widget.plant.notes,
    );

    _healthStatus = _normalizeHealthStatus(
      widget.plant.healthStatus,
    );
  }

  String _normalizeHealthStatus(String status) {
    final normalized = status.trim().toLowerCase();

    if (normalized == 'needs care' ||
        normalized == 'perlu perhatian') {
      return 'Needs Care';
    }

    return 'Healthy';
  }

  @override
  void dispose() {
    _scheduleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitEdit() async {
    if (!_formKey.currentState!.validate() ||
        widget.plant.id == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final updates = {
      'water_schedule': _scheduleController.text.trim(),
      'notes': _notesController.text.trim(),
      'health_status': _healthStatus,
    };

    final provider = Provider.of<MyPlantProvider>(
      context,
      listen: false,
    );

    try {
      final success = await provider.updatePlant(
        widget.plant.id!,
        updates,
      );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data tanaman berhasil diperbarui!'),
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memperbarui: ${provider.errorMessage}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF4CAF50);
    const backgroundColor = Color(0xFFF8F9FA);
    const textDark = Color(0xFF2D3748);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        centerTitle: true,
        title: const Text(
          'Edit Tanaman',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Informasi tanaman
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco_outlined,
                        color: primaryGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tanaman yang diedit',
                            style: TextStyle(
                              color: Color(0xFF718096),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.plant.plantName,
                            style: const TextStyle(
                              color: textDark,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Form edit
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Perawatan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Jadwal penyiraman
                    TextFormField(
                      controller: _scheduleController,
                      decoration: _inputDecoration(
                        'Jadwal Penyiraman',
                        Icons.schedule,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Jadwal siram wajib diisi'
                              : null,
                    ),

                    const SizedBox(height: 16),

                    // Status kesehatan
                    DropdownButtonFormField<String>(
                      initialValue: _healthStatus,
                      isExpanded: true,
                      decoration: _inputDecoration(
                        'Status Kesehatan',
                        Icons.health_and_safety_outlined,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Healthy',
                          child: Text('Sehat'),
                        ),
                        DropdownMenuItem(
                          value: 'Needs Care',
                          child: Text('Perlu Perhatian'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _healthStatus = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Catatan
                    TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: _inputDecoration(
                        'Catatan Perawatan',
                        Icons.note_outlined,
                      ).copyWith(
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tombol simpan
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primaryGreen.withValues(
                      alpha: 0.6,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF718096),
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF4CAF50),
      ),
      filled: true,
      fillColor: const Color(0xFFF7FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF4CAF50),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }
}
