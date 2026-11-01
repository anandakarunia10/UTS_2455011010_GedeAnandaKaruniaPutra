import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/my_plant_provider.dart';
import '../widgets/plant_card.dart';
import '../widgets/status_badge.dart';
import 'edit_plant_screen.dart';

class MyGardenScreen extends StatefulWidget {
  const MyGardenScreen({super.key});

  @override
  State<MyGardenScreen> createState() => _MyGardenScreenState();
}

class _MyGardenScreenState extends State<MyGardenScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<MyPlantProvider>(context, listen: false).fetchMyPlants();
    });
  }

  void _confirmDelete(BuildContext context, String id, String plantName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus "$plantName" dari Kebunku?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              final provider = Provider.of<MyPlantProvider>(context, listen: false);
              final success = await provider.deletePlant(id);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Tanaman berhasil dihapus'
                        : 'Gagal menghapus tanaman',
                  ),
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gardenProvider = Provider.of<MyPlantProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kebunku (Database)'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: _buildContent(gardenProvider),
    );
  }

  Widget _buildContent(MyPlantProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text(provider.errorMessage, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () => provider.fetchMyPlants(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (provider.myPlants.isEmpty) {
      return const Center(
        child: Text('Belum ada tanaman tersimpan di Kebunku.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: provider.myPlants.length,
      itemBuilder: (context, index) {
        final item = provider.myPlants[index];
        return PlantCard(
          title: item.plantName,
          subtitle: 'Jadwal: ${item.waterSchedule} | Terakhir: ${item.lastWateredDate}',
          imageUrl: item.imageUrl,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusBadge(status: item.healthStatus),
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPlantScreen(plant: item),
                      ),
                    );
                  } else if (val == 'delete' && item.id != null) {
                    _confirmDelete(context, item.id!, item.plantName);
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Hapus', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPlantScreen(plant: item),
              ),
            );
          },
        );
      },
    );
  }
}