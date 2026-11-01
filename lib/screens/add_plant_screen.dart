import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/my_plant_model.dart';
import '../models/plant_api_model.dart';
import '../providers/my_plant_provider.dart';
import '../widgets/custom_button.dart';

class AddPlantScreen extends StatefulWidget {
  final PlantApiModel plant;

  const AddPlantScreen({super.key, required this.plant});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scheduleController = TextEditingController(text: '2 Hari sekali');
  final _notesController = TextEditingController();
  String _healthStatus = 'Healthy';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _scheduleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final now = DateTime.now();
    final dateStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final newPlant = MyPlantModel(
      studentId: '2455011010',
      plantId: widget.plant.id,
      plantName: widget.plant.commonName,
      waterSchedule: _scheduleController.text.trim(),
      lastWateredDate: dateStr,
      notes: _notesController.text.trim(),
      healthStatus: _healthStatus,
      imageUrl: widget.plant.imageUrl,
    );

    final provider = Provider.of<MyPlantProvider>(context, listen: false);
    final success = await provider.addPlant(newPlant);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanaman berhasil ditambahkan ke Kebunku!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: ${provider.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah ke Kebunku'),
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
                'Tanaman: ${widget.plant.commonName}',
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
                  labelText: 'Status Kesehatan awal',
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
                  labelText: 'Catatan Perawatan (Opsional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Simpan Tanaman',
                  isLoading: _isSubmitting,
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}