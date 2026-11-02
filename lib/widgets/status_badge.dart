
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.trim().toLowerCase();

    final bool isHealthy =
        normalizedStatus == 'healthy' ||
        normalizedStatus == 'sehat';

    final bool needsCare =
        normalizedStatus == 'needs care' ||
        normalizedStatus == 'perlu perhatian';

    final Color color = isHealthy
        ? Colors.green
        : needsCare
            ? Colors.orange
            : Colors.grey;

    final String label = isHealthy
        ? 'Sehat'
        : needsCare
            ? 'Perlu Perhatian'
            : status;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isHealthy
                ? Icons.check_circle_outline
                : Icons.warning_amber_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
