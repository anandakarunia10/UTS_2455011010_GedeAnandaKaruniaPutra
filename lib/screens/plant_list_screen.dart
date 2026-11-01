import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/plant_provider.dart';
import '../models/plant_api_model.dart';
import 'plant_detail_screen.dart';

class PlantListScreen extends StatefulWidget {
  const PlantListScreen({super.key});

  @override
  State<PlantListScreen> createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlantProvider>(context, listen: false).fetchPlants();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF88B04B);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F2),
      appBar: AppBar(
        title: const Text(
          'Katalog Tanaman',
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
      ),
      body: Column(
        children: [
          // Search Bar Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari tanaman...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: primaryGreen),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),

          // Plant List Content Section
          Expanded(
            child: Consumer<PlantProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryGreen,
                    ),
                  );
                }

                if (provider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade300),
                          const SizedBox(height: 12),
                          Text(
                            provider.errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => provider.fetchPlants(),
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Coba Lagi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filteredPlants = provider.plants.where((plant) {
                  final commonName = plant.commonName.toLowerCase();
                  final scientificName = plant.scientificName.join(' ').toLowerCase();
                  return commonName.contains(_searchQuery) || scientificName.contains(_searchQuery);
                }).toList();

                if (filteredPlants.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.nature_outlined, size: 56, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Tidak ada data tanaman'
                              : 'Tanaman "$_searchQuery" tidak ditemukan',
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: primaryGreen,
                  onRefresh: () async {
                    await provider.fetchPlants();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: filteredPlants.length,
                    itemBuilder: (context, index) {
                      final plant = filteredPlants[index];
                      return _buildPlantCard(context, plant, primaryGreen);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCard(BuildContext context, PlantApiModel plant, Color primaryGreen) {
    final scientificNameText = plant.scientificName.isNotEmpty
        ? plant.scientificName.join(', ')
        : 'Nama ilmiah tidak tersedia';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantDetailScreen(plant: plant),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Plant Image Container
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F3EC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: plant.imageUrl.isNotEmpty
                        ? Image.network(
                            plant.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.local_florist,
                              color: primaryGreen,
                              size: 32,
                            ),
                          )
                        : Icon(
                            Icons.local_florist,
                            color: primaryGreen,
                            size: 32,
                          ),
                  ),
                ),
                const SizedBox(width: 14),

                // Plant Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.commonName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scientificNameText,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildMiniBadge(
                            icon: Icons.water_drop_rounded,
                            label: plant.watering,
                            color: Colors.blue.shade600,
                            bgColor: const Color(0xFFE3F2FD),
                          ),
                          const SizedBox(width: 8),
                          _buildMiniBadge(
                            icon: Icons.wb_sunny_rounded,
                            label: plant.sunlight.isNotEmpty ? plant.sunlight : 'Normal',
                            color: Colors.amber.shade800,
                            bgColor: const Color(0xFFFFF8E1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow Action Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F6F2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: primaryGreen,
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniBadge({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 70),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}