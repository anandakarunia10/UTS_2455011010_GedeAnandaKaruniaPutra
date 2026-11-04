
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/my_plant_model.dart';
import '../providers/my_plant_provider.dart';
import '../providers/watering_history_provider.dart';

class WateringHistoryScreen extends StatefulWidget {
  final MyPlantModel plant;

  const WateringHistoryScreen({
    super.key,
    required this.plant,
  });

  @override
  State<WateringHistoryScreen> createState() =>
      _WateringHistoryScreenState();
}

class _WateringHistoryScreenState
    extends State<WateringHistoryScreen> {
  static const Color _primaryGreen = Color(0xFF83A936);
  static const Color _background = Color(0xFFF4F6F1);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted || widget.plant.id == null) return;

      context.read<WateringHistoryProvider>().fetchHistory(
            widget.plant.id!,
          );
    });
  }

  Widget _buildPlantImage() {
    final imageUrl = widget.plant.imageUrl.trim();
    final uri = Uri.tryParse(imageUrl);
    final isValidUrl = uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;

    if (!isValidUrl) {
      return _buildPlantImagePlaceholder();
    }

    return Image.network(
      imageUrl,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildPlantImagePlaceholder();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlantImagePlaceholder();
      },
    );
  }

  Widget _buildPlantImagePlaceholder() {
    return Container(
      width: 48,
      height: 48,
      color: const Color(0xFFE8F0DC),
      alignment: Alignment.center,
      child: const Icon(
        Icons.local_florist,
        color: _primaryGreen,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();

    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final year = localDate.year.toString();
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');

    return '$day/$month/$year • $hour:$minute';
  }

  String _formatLastWateredDate(DateTime date) {
    final localDate = date.toLocal();

    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final year = localDate.year.toString();

    return '$day/$month/$year';
  }

  Future<void> _addWatering() async {
    final notes = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return const _WateringNotesDialog();
      },
    );

    if (notes == null || !mounted) return;
    if (widget.plant.id == null) return;

    final historyProvider = context.read<WateringHistoryProvider>();

    final success = await historyProvider.addWateringHistory(
      plantId: widget.plant.id!,
      notes: notes.isEmpty ? null : notes,
    );

    if (!mounted) return;

    if (success) {
      final now = DateTime.now();

      final updateSuccess = await context
          .read<MyPlantProvider>()
          .updatePlant(
        widget.plant.id!,
        {
          'last_watered_date': _formatLastWateredDate(now),
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            updateSuccess
                ? 'Riwayat penyiraman berhasil disimpan'
                : 'Riwayat tersimpan, tetapi tanggal terakhir gagal diperbarui',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan riwayat: ${historyProvider.errorMessage ?? 'Terjadi kesalahan'}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteHistory(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Riwayat'),
          content: const Text(
            'Yakin ingin menghapus catatan penyiraman ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;
    if (widget.plant.id == null) return;

    final success = await context
        .read<WateringHistoryProvider>()
        .deleteWateringHistory(
          id: id,
          plantId: widget.plant.id!,
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Riwayat berhasil dihapus'
              : 'Gagal menghapus riwayat',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Riwayat Penyiraman',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _background,
        foregroundColor: const Color(0xFF1C2718),
        elevation: 0,
      ),
      body: widget.plant.id == null
          ? const Center(
              child: Text('ID tanaman tidak ditemukan.'),
            )
          : Consumer<WateringHistoryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: _primaryGreen,
                    ),
                  );
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 42,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            provider.errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              provider.fetchHistory(widget.plant.id!);
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                            ClipOval(
                            child: _buildPlantImage(),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tanaman',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  widget.plant.plantName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: provider.histories.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.water_drop_outlined,
                                    size: 52,
                                    color: Colors.blueGrey,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Belum ada riwayat penyiraman',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: provider.histories.length,
                              itemBuilder: (context, index) {
                                final history =
                                    provider.histories[index];

                                return Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.water_drop_rounded,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _formatDate(history.wateredAt),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            if (history.notes != null &&
                                                history.notes!.isNotEmpty) ...[
                                              const SizedBox(height: 5),
                                              Text(
                                                history.notes!,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (history.id != null)
                                        IconButton(
                                          tooltip: 'Hapus riwayat',
                                          onPressed: () =>
                                              _deleteHistory(history.id!),
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed:
                              provider.isSaving ? null : _addWatering,
                          icon: provider.isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.water_drop_rounded),
                          label: Text(
                            provider.isSaving
                                ? 'Menyimpan...'
                                : 'Sudah Disiram',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

// Dialog memiliki controller sendiri.
// Controller baru di-dispose ketika widget dialog benar-benar dilepas.
class _WateringNotesDialog extends StatefulWidget {
  const _WateringNotesDialog();

  @override
  State<_WateringNotesDialog> createState() =>
      _WateringNotesDialogState();
}

class _WateringNotesDialogState extends State<_WateringNotesDialog> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Catatan Penyiraman'),
      content: TextField(
        controller: _notesController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Contoh: Menyiram hingga tanah lembap',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              _notesController.text.trim(),
            );
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
