import 'package:flutter/material.dart';

import 'button.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  // ─── FACTORY PRESETS ──────────────────────────────────
  factory EmptyState.noLists({VoidCallback? onAction}) {
    return EmptyState(
      icon: Icons.playlist_add,
      title: 'Aucune liste',
      subtitle: 'Créez votre première liste pour commencer',
      actionText: 'Créer une liste',
      onAction: onAction,
    );
  }

  factory EmptyState.noItems() {
    return const EmptyState(
      icon: Icons.checklist,
      title: 'Liste vide',
      subtitle: 'Ajoutez des éléments à votre checklist',
    );
  }

  factory EmptyState.noSharedLists() {
    return const EmptyState(
      icon: Icons.people_outline,
      title: 'Aucune liste partagée',
      subtitle: 'Les listes partagées avec vous apparaîtront ici',
    );
  }

  factory EmptyState.noSearchResults() {
    return const EmptyState(
      icon: Icons.search_off,
      title: 'Aucun résultat',
      subtitle: 'Essayez avec d\'autres termes de recherche',
    );
  }

  factory EmptyState.noCalendarLists() {
    return const EmptyState(
      icon: Icons.event_available,
      title: 'Rien de prévu',
      subtitle: 'Aucune liste planifiée pour cette date',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 56, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              SmartButton(
                text: actionText!,
                onPressed: onAction,
                isFullWidth: false,
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}