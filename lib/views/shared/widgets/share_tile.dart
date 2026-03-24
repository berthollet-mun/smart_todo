import 'package:flutter/material.dart';

import '../../data/models/share_model.dart';
import '../../data/models/user_model.dart';
import 'avatar.dart';
import 'status_chip.dart';

/// Tile pour un utilisateur partagé (dans le détail d'une liste)
class ShareTile extends StatelessWidget {
  final ShareModel share;
  final VoidCallback? onRemove;
  final bool isOwner;

  const ShareTile({
    super.key,
    required this.share,
    this.onRemove,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          SmartAvatar(name: share.sharedWithName, radius: 18, fontSize: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  share.sharedWithName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  share.sharedWithEmail,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          StatusChip.permission(share.permission),
          if (isOwner && onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close,
                size: 18,
                color: Colors.red.shade400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Tile pour un résultat de recherche d'utilisateur (lors du partage)
class UserSearchTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final bool isAlreadyShared;

  const UserSearchTile({
    super.key,
    required this.user,
    this.onTap,
    this.isAlreadyShared = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SmartAvatar(name: user.name, radius: 20),
      title: Text(
        user.name,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        user.email,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: isAlreadyShared
          ? Chip(
              label: const Text('Déjà partagé', style: TextStyle(fontSize: 10)),
              backgroundColor: Colors.grey.shade200,
            )
          : Icon(
              Icons.person_add_outlined,
              color: Theme.of(context).primaryColor,
            ),
      onTap: isAlreadyShared ? null : onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}