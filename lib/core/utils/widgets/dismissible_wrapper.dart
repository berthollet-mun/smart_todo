import 'package:flutter/material.dart';

/// Wrapper pour swipe-to-delete / swipe-to-action
class DismissibleWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;
  final String deleteLabel;
  final String editLabel;
  final bool confirmDismiss;

  const DismissibleWrapper({
    super.key,
    required this.child,
    required this.onDelete,
    this.onEdit,
    this.deleteLabel = 'Supprimer',
    this.editLabel = 'Modifier',
    this.confirmDismiss = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key ?? UniqueKey(),
      direction: onEdit != null
          ? DismissDirection.horizontal
          : DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          if (confirmDismiss) {
            return await _showConfirm(context);
          }
          return true;
        }
        if (direction == DismissDirection.startToEnd && onEdit != null) {
          onEdit!();
          return false; // Ne pas supprimer, juste déclencher l'action
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      // Swipe vers la gauche → Supprimer
      background: onEdit != null
          ? _buildEditBackground()
          : const SizedBox.shrink(),
      secondaryBackground: _buildDeleteBackground(),
      child: child,
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red.shade500,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.delete_outline, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            deleteLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 24),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade500,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.edit_outlined, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            editLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirm(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer cet élément ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}