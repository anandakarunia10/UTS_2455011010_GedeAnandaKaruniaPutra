import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/my_plant_model.dart';
import '../providers/my_plant_provider.dart';
import '../widgets/custom_button.dart';

class EditPlantScreen extends StatefulWidget {
  final MyPlantModel plant;

  const EditPlantScreen({super.key, required this.plant});

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
    _scheduleController = TextEditingController(text: widget.plant.waterSchedule);
    _notesController = TextEditingController(text: widget.plant.notes);
    _healthStatus = widget.plant.healthStatus;
  }

  @override
  void dispose() {
    _scheduleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitEdit() async {
    if (!_formKey.currentState!.validate() || widget.plant.id == null) return;

    setState(() => _isSubmitting = true);

    final updates = {
      'water_schedule': _scheduleController.text.trim(),
      'notes': _notesController.text.trim(),
      'health_status': _healthStatus,
    };

    final provider = Provider.of<MyPlantProvider>(context, listen: false);
    final success = await provider.updatePlant(widget.plant.id!, updates);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data tanaman berhasil diperbarui!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui: ${provider.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan Tanaman'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit: ${widget.plant.plantName}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scheduleController,
                decoration: const InputDecoration(
                  labelText: 'Jadwal Penyiraman',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Jadwal siram wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _healthStatus,
                decoration: const InputDecoration(
                  labelText: 'Status Kesehatan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.health_and_safety),
                ),
                items: const [
                  DropdownMenuItem(value: 'Healthy', child: Text('Sehat')),
                  DropdownMenuItem(value: 'Needs Care', child: Text('Perlu Perhatian')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _healthStatus = val);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan Perawatan',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Simpan Perubahan',
                  isLoading: _isSubmitting,
                  onPressed: _submitEdit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}