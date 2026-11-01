
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/my_plant_provider.dart';
import '../models/my_plant_model.dart';
import '../models/plant_api_model.dart';

class AddPlantScreen extends StatefulWidget {
  final MyPlantModel? plant;
  final PlantApiModel? catalogPlant;

  const AddPlantScreen({
    super.key,
    this.plant,
    this.catalogPlant,
  });

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _scheduleController;
  late TextEditingController _lastWateredController;
  late TextEditingController _imageController;
  late TextEditingController _statusController;
  late TextEditingController _notesController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.plant?.plantName ??
          widget.catalogPlant?.commonName ??
          '',
    );

    _scheduleController = TextEditingController(
      text: widget.plant?.waterSchedule ??
          widget.catalogPlant?.watering ??
          '',
    );

    _lastWateredController = TextEditingController(
      text: widget.plant?.lastWateredDate ?? '',
    );

    _imageController = TextEditingController(
      text: widget.plant?.imageUrl ??
          widget.catalogPlant?.imageUrl ??
          '',
    );

    _statusController = TextEditingController(
      text: widget.plant?.healthStatus ?? 'Sehat',
    );

    _notesController = TextEditingController(
      text: widget.plant?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scheduleController.dispose();
    _lastWateredController.dispose();
    _imageController.dispose();
    _statusController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePlant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<MyPlantProvider>(
      context,
      listen: false,
    );

    final newPlant = MyPlantModel(
      id: widget.plant?.id,
      studentId: widget.plant?.studentId ?? '2455011010',
      plantId: widget.plant?.plantId ??
          widget.catalogPlant?.id ??
          0,
      plantName: _nameController.text.trim(),
      waterSchedule: _scheduleController.text.trim(),
      lastWateredDate: _lastWateredController.text.trim(),
      imageUrl: _imageController.text.trim(),
      healthStatus: _statusController.text.trim(),
      notes: _notesController.text.trim(),
    );

    bool success;

    if (widget.plant == null || widget.plant!.id == null) {
      success = await provider.addPlant(newPlant);
    } else {
      success = await provider.updatePlant(
        widget.plant!.id!,
        newPlant.toJson(),
      );
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan tanaman'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing =
        widget.plant != null && widget.plant!.id != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2D3748),
        title: Text(
          isEditing ? 'Edit Tanaman' : 'Tambah Tanaman',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(
                        'Nama Tanaman',
                        Icons.eco_outlined,
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Nama tanaman tidak boleh kosong'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _scheduleController,
                      decoration: _inputDecoration(
                        'Jadwal Penyiraman',
                        Icons.schedule,
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Jadwal tidak boleh kosong'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastWateredController,
                      decoration: _inputDecoration(
                        'Terakhir Disiram',
                        Icons.water_drop_outlined,
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Tanggal siram terakhir tidak boleh kosong'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageController,
                      decoration: _inputDecoration(
                        'URL Gambar Tanaman',
                        Icons.image_outlined,
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'URL gambar tidak boleh kosong'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _statusController,
                      decoration: _inputDecoration(
                        'Status Kesehatan',
                        Icons.health_and_safety_outlined,
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Status kesehatan tidak boleh kosong'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: _inputDecoration(
                        'Catatan',
                        Icons.note_outlined,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePlant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isEditing
                              ? 'Simpan Perubahan'
                              : 'Tambah Tanaman',
                          style: const TextStyle(
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
