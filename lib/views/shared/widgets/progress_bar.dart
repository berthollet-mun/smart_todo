import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double percentage;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showLabel;
  final int completedItems;
  final int totalItems;

  const ProgressBar({
    super.key,
    required this.percentage,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
    this.showLabel = false,
    this.completedItems = 0,
    this.totalItems = 0,
  });

  Color _getColor() {
    if (progressColor != null) return progressColor!;
    if (percentage >= 100) return Colors.green.shade500;
    if (percentage >= 60) return Colors.blue.shade500;
    if (percentage >= 30) return Colors.orange.shade500;
    return Colors.red.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final clamped = percentage.clamp(0.0, 100.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completedItems / $totalItems',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${clamped.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: SizedBox(
            height: height,
            child: LinearProgressIndicator(
              value: clamped / 100,
              backgroundColor: backgroundColor ?? Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}