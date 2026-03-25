import 'package:flutter/material.dart';
import 'package:smart_todo/core/utils/widgets/date_time_helper.dart';
import 'package:smart_todo/data/models/task_list_model.dart';

import 'progress_bar.dart';
import 'status_chip.dart';

class TaskCard extends StatelessWidget {
  final TaskListModel list;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showOwner;

  const TaskCard({
    super.key,
    required this.list,
    this.onTap,
    this.onLongPress,
    this.showOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: list.isCompleted
            ? Border.all(color: Colors.green.shade200)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Ligne 1 : Chips + Type ───────────────
                Row(
                  children: [
                    StatusChip.fromStatus(
                      list.status,
                      dueDate: list.dueDate,
                    ),
                    const SizedBox(width: 6),
                    StatusChip.listType(list.type),
                    const Spacer(),
                    if (list.sharedWith.isNotEmpty || list.permission != null)
                      StatusChip.shared(),
                  ],
                ),
                const SizedBox(height: 10),

                // ─── Ligne 2 : Titre ──────────────────────
                Text(
                  list.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    decoration: list.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // ─── Ligne 3 : Description ────────────────
                if (list.description != null &&
                    list.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    list.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // ─── Ligne 4 : Propriétaire (shared) ──────
                if (showOwner && list.ownerName != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        list.ownerName!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      if (list.permission != null) ...[
                        const SizedBox(width: 8),
                        StatusChip.permission(list.permission!),
                      ],
                    ],
                  ),
                ],

                const SizedBox(height: 10),

                // ─── Ligne 5 : Progress + Date ────────────
                Row(
                  children: [
                    // Progress bar (checklist)
                    if (list.isChecklist) ...[
                      Expanded(
                        child: ProgressBar(
                          percentage: list.completionPercentage,
                          showLabel: true,
                          completedItems: list.completedItems,
                          totalItems: list.totalItems,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],

                    // Date
                    if (list.dueDate != null) ...[
                      if (!list.isChecklist) const Spacer(),
                      _buildDateChip(),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateChip() {
    final isPastDue = DateTimeHelper.isPast(list.dueDate) && list.isActive;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_today,
          size: 13,
          color: isPastDue ? Colors.red.shade400 : Colors.grey.shade500,
        ),
        const SizedBox(width: 4),
        Text(
          DateTimeHelper.relativeLabel(list.dueDate),
          style: TextStyle(
            fontSize: 12,
            color: isPastDue ? Colors.red.shade400 : Colors.grey.shade500,
            fontWeight: isPastDue ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        if (list.dueTime != null) ...[
          const SizedBox(width: 4),
          Text(
            DateTimeHelper.displayTime(list.dueTime),
            style: TextStyle(
              fontSize: 12,
              color: isPastDue ? Colors.red.shade400 : Colors.grey.shade500,
            ),
          ),
        ],
      ],
    );
  }
}