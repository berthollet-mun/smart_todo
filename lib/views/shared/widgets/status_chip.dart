import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final double fontSize;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.fontSize = 11,
  });

  // ─── FACTORY PRESETS ──────────────────────────────────
  factory StatusChip.active() => StatusChip(
        label: 'Active',
        color: Colors.blue.shade600,
        icon: Icons.radio_button_checked,
      );

  factory StatusChip.completed() => StatusChip(
        label: 'Terminée',
        color: Colors.green.shade600,
        icon: Icons.check_circle,
      );

  factory StatusChip.overdue() => StatusChip(
        label: 'En retard',
        color: Colors.red.shade600,
        icon: Icons.warning_amber_rounded,
      );

  factory StatusChip.shared() => StatusChip(
        label: 'Partagée',
        color: Colors.purple.shade600,
        icon: Icons.people_outline,
      );

  factory StatusChip.permission(String permission) {
    final isEdit = permission == 'edit';
    return StatusChip(
      label: isEdit ? 'Édition' : 'Lecture',
      color: isEdit ? Colors.orange.shade600 : Colors.grey.shade600,
      icon: isEdit ? Icons.edit : Icons.visibility,
    );
  }

  factory StatusChip.listType(String type) {
    final isChecklist = type == 'checklist';
    return StatusChip(
      label: isChecklist ? 'Checklist' : 'Simple',
      color: isChecklist ? Colors.teal.shade600 : Colors.indigo.shade400,
      icon: isChecklist ? Icons.checklist : Icons.notes,
    );
  }

  /// Depuis le status d'une TaskListModel
  factory StatusChip.fromStatus(String status, {String? dueDate}) {
    if (status == 'completed') return StatusChip.completed();
    // Vérifier si en retard
    if (dueDate != null) {
      try {
        final date = DateTime.parse(dueDate);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        if (date.isBefore(today) && status == 'active') {
          return StatusChip.overdue();
        }
      } catch (_) {}
    }
    return StatusChip.active();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}