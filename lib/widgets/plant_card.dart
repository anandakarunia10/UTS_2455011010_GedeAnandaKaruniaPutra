
import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Widget? trailing;
  final VoidCallback onTap;

  const PlantCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.trailing,
    required this.onTap,
  });

  Widget _buildImagePlaceholder() {
    return Container(
      width: 70,
      height: 70,
      color: const Color(0xFFE8F0DC),
      alignment: Alignment.center,
      child: const Icon(
        Icons.local_florist_rounded,
        color: Color(0xFF88B04B),
        size: 30,
      ),
    );
  }

  Widget _buildPlantImage() {
    final normalizedUrl = imageUrl.trim();
    final uri = Uri.tryParse(normalizedUrl);
    final isValidUrl = uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;

    if (!isValidUrl) {
      return _buildImagePlaceholder();
    }

    return Image.network(
      normalizedUrl,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildImagePlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildImagePlaceholder();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildPlantImage(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
