import 'package:flutter/material.dart';

import 'button.dart';

class SmartErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const SmartErrorWidget({
    super.key,
    this.message = 'Une erreur est survenue',
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  factory SmartErrorWidget.network({VoidCallback? onRetry}) {
    return SmartErrorWidget(
      message: 'Pas de connexion internet.\nVérifiez votre réseau.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }

  factory SmartErrorWidget.server({VoidCallback? onRetry}) {
    return SmartErrorWidget(
      message: 'Le serveur ne répond pas.\nRéessayez plus tard.',
      icon: Icons.cloud_off,
      onRetry: onRetry,
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
            Icon(icon, size: 56, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              SmartButton(
                text: 'Réessayer',
                onPressed: onRetry,
                type: SmartButtonType.outline,
                isFullWidth: false,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}