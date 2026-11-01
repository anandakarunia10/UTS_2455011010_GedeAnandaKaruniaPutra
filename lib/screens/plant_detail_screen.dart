import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant_api_model.dart';
import '../models/my_plant_model.dart';
import '../providers/my_plant_provider.dart';

class PlantDetailScreen extends StatelessWidget {
  final PlantApiModel plant;

  const PlantDetailScreen({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF88B04B);

    final scientificNameText = plant.scientificName.isNotEmpty
        ? plant.scientificName.join(', ')
        : 'Nama ilmiah tidak tersedia';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F2),
      appBar: AppBar(
        title: const Text(
          'Detail Tanaman',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Container Gambar Tanaman
                  Container(
                    width: double.infinity,
                    height: 240,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F3EC),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: plant.imageUrl.isNotEmpty
                          ? Image.network(
                              plant.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.local_florist_rounded,
                                size: 80,
                                color: primaryGreen,
                              ),
                            )
                          : Icon(
                              Icons.local_florist_rounded,
                              size: 80,
                              color: primaryGreen,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nama Umum & Nama Ilmiah
                  Text(
                    plant.commonName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scientificNameText,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cards Ringkasan Perawatan
                  Row(
                    children: [
                      Expanded(
                        child: _buildCareMetricCard(
                          icon: Icons.water_drop_rounded,
                          title: 'Penyiraman',
                          value: plant.watering.isNotEmpty ? plant.watering : '-',
                          iconColor: Colors.blue.shade600,
                          bgColor: const Color(0xFFE3F2FD),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCareMetricCard(
                          icon: Icons.wb_sunny_rounded,
                          title: 'Pencahayaan',
                          value: plant.sunlight.isNotEmpty ? plant.sunlight : '-',
                          iconColor: Colors.amber.shade800,
                          bgColor: const Color(0xFFFFF8E1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCareMetricCard(
                          icon: Icons.grass_rounded,
                          title: 'Kategori',
                          value: 'Tanaman',
                          iconColor: primaryGreen,
                          bgColor: const Color(0xFFE8F0DC),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Informasi Detail Tambahan
                  Container(
                    width: double.infinity,
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
                          'Informasi Lengkap',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          label: 'Nama Ilmiah',
                          value: scientificNameText,
                        ),
                        const Divider(height: 24, thickness: 0.8),
                        _buildDetailRow(
                          label: 'Kebutuhan Air',
                          value: plant.watering.isNotEmpty ? plant.watering : 'Tidak tersedia',
                        ),
                        const Divider(height: 24, thickness: 0.8),
                        _buildDetailRow(
                          label: 'Sinar Matahari',
                          value: plant.sunlight.isNotEmpty ? plant.sunlight : 'Tidak tersedia',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Action Button: Tambah ke Kebunku
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  final gardenProvider = Provider.of<MyPlantProvider>(context, listen: false);

                  final newMyPlant = MyPlantModel(
                    studentId: '2455011010',
                    plantId: plant.id,
                    plantName: plant.commonName,
                    waterSchedule: plant.watering,
                    lastWateredDate: DateTime.now().toString(),
                    imageUrl: plant.imageUrl,
                    healthStatus: 'Healthy',
                    notes: 'Ditambahkan dari katalog tanaman.',
                  );

                  gardenProvider.addPlant(newMyPlant);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${plant.commonName} berhasil ditambahkan ke Kebunku!'),
                      backgroundColor: primaryGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded, size: 22),
                label: const Text(
                  'Tambah ke Kebunku',
                  style: TextStyle(
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
          ),
        ],
      ),
    );
  }

  Widget _buildCareMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}