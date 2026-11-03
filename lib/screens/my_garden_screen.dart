
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/my_plant_provider.dart';
import '../widgets/plant_card.dart';
import '../widgets/status_badge.dart';
import 'edit_plant_screen.dart';
import 'watering_history_screen.dart';

class MyGardenScreen extends StatefulWidget {
  const MyGardenScreen({super.key});

  @override
  State<MyGardenScreen> createState() => _MyGardenScreenState();
}

class _MyGardenScreenState extends State<MyGardenScreen> {
  static const Color _bgColor = Color(0xFFF4F6F1);
  static const Color _primaryGreen = Color(0xFF83A936);
  static const Color _textDark = Color(0xFF1C2718);
  static const Color _textMuted = Color(0xFF707E68);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      Provider.of<MyPlantProvider>(
        context,
        listen: false,
      ).fetchMyPlants();
    });
  }

  void _confirmDelete(
    BuildContext context,
    String id,
    String plantName,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        contentPadding: const EdgeInsets.all(24),
        title: const Text(
          'Konfirmasi Hapus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: _textDark,
          ),
        ),
        content: Text(
          'Yakin ingin menghapus "$plantName" dari Kebunku?',
          style: const TextStyle(
            color: _textMuted,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.only(
          right: 16,
          bottom: 16,
          left: 16,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              foregroundColor: _textMuted,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            onPressed: () async {
              Navigator.pop(ctx);

              final provider = Provider.of<MyPlantProvider>(
                context,
                listen: false,
              );

              final success = await provider.deletePlant(id);

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: success
                      ? _primaryGreen
                      : Colors.red.shade600,
                  content: Text(
                    success
                        ? 'Tanaman berhasil dihapus'
                        : 'Gagal menghapus tanaman',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openWateringHistory(BuildContext context, item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WateringHistoryScreen(
          plant: item,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gardenProvider = Provider.of<MyPlantProvider>(context);

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: const Text(
          'Kebunku',
          style: TextStyle(
            color: _textDark,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: _bgColor,
        foregroundColor: _textDark,
        elevation: 0,
        centerTitle: false,
      ),
      body: _buildContent(gardenProvider),
    );
  }

  Widget _buildContent(MyPlantProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: _primaryGreen,
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                provider.errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => provider.fetchMyPlants(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.myPlants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFEBF2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.eco_outlined,
                size: 56,
                color: _primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada tanaman tersimpan di Kebunku.',
              style: TextStyle(
                color: _textMuted,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      itemCount: provider.myPlants.length,
      itemBuilder: (context, index) {
        final item = provider.myPlants[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
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
            clipBehavior: Clip.antiAlias,
            child: PlantCard(
              title: item.plantName,
              subtitle:
                  'Jadwal: ${item.waterSchedule} | Terakhir: ${item.lastWateredDate}',
              imageUrl: item.imageUrl,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusBadge(status: item.healthStatus),
                  PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    icon: const Icon(
                      Icons.more_vert,
                      color: _textMuted,
                    ),
                    onSelected: (val) {
                      if (val == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditPlantScreen(plant: item),
                          ),
                        );
                      } else if (val == 'history') {
                        _openWateringHistory(context, item);
                      } else if (val == 'delete' &&
                          item.id != null) {
                        _confirmDelete(
                          context,
                          item.id!,
                          item.plantName,
                        );
                      }
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: _textDark,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: _textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'history',
                        child: Row(
                          children: [
                            Icon(
                              Icons.history,
                              size: 18,
                              color: _primaryGreen,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Riwayat Penyiraman',
                              style: TextStyle(
                                color: _textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Colors.red,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Hapus',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditPlantScreen(plant: item),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
