import 'package:flutter/material.dart';
import '../models/plant_api_model.dart';
import '../widgets/custom_button.dart';
import 'add_plant_screen.dart';

class PlantDetailScreen extends StatelessWidget {
  final PlantApiModel plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.commonName),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                plant.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.local_florist, size: 80, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              plant.commonName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              plant.scientificName.join(', '),
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
            const Divider(height: 32),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.water_drop, color: Colors.blue),
                      title: const Text('Jadwal Penyiraman'),
                      subtitle: Text(plant.watering),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.wb_sunny, color: Colors.orange),
                      title: const Text('Kebutuhan Sinar Matahari'),
                      subtitle: Text(plant.sunlight),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Simpan ke Kebunku',
                icon: Icons.add_task,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPlantScreen(plant: plant),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}