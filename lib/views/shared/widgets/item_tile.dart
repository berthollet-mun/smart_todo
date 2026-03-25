import 'package:flutter/material.dart';

import '../../data/models/item_model.dart';

class ItemTile extends StatelessWidget {
  final ItemModel item;
  final VoidCallback? onToggle;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool enabled;

  const ItemTile({
    super.key,
    required this.item,
    this.onToggle,
    this.onEdit,
    this.onDelete,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: item.isDone ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: item.isDone
              ? Colors.green.shade200
              : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: GestureDetector(
          onTap: enabled ? onToggle : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: item.isDone
                  ? Colors.green.shade500
                  : Colors.transparent,
              border: Border.all(
                color: item.isDone
                    ? Colors.green.shade500
                    : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: item.isDone
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontSize: 14,
            color: item.isDone ? Colors.grey.shade500 : Colors.black87,
            decoration: item.isDone ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: enabled
            ? PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Supprimer',
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') onEdit?.call();
                  if (value == 'delete') onDelete?.call();
                },
              )
            : null,
      ),
    );
  }
}