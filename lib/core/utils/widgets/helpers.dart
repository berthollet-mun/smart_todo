import 'package:flutter/material.dart';
import 'package:get_x/get_core/src/get_main.dart';
import 'package:get_x/get_navigation/src/extension_navigation.dart';
import 'package:get_x/get_navigation/src/snackbar/snackbar.dart';


class Helpers {
  Helpers._();

  // ═══════════════════════════════════════════════════════
  // SNACKBARS
  // ═══════════════════════════════════════════════════════

  static void showSuccess(String message) {
    _closeCurrentSnackbar();
    Get.snackbar(
      'Succès',
      message,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.top,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showError(String message) {
    _closeCurrentSnackbar();
    Get.snackbar(
      'Erreur',
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.top,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  static void showWarning(String message) {
    _closeCurrentSnackbar();
    Get.snackbar(
      'Attention',
      message,
      backgroundColor: Colors.orange.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.top,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
    );
  }

  static void showInfo(String message) {
    _closeCurrentSnackbar();
    Get.snackbar(
      'Info',
      message,
      backgroundColor: Colors.blue.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.top,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }

  /// Snackbar avec action (ex: "Annuler la suppression")
  static void showWithAction({
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    Duration duration = const Duration(seconds: 5),
  }) {
    _closeCurrentSnackbar();
    Get.snackbar(
      '',
      message,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.bottom,
      duration: duration,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      mainButton: TextButton(
        onPressed: () {
          _closeCurrentSnackbar();
          onAction();
        },
        child: Text(
          actionLabel,
          style: const TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static void _closeCurrentSnackbar() {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
  }

  // ═══════════════════════════════════════════════════════
  // DIALOGS
  // ═══════════════════════════════════════════════════════

  /// Dialog de confirmation (Supprimer, Déconnexion, etc.)
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
    Color confirmColor = Colors.red,
    IconData? icon,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: confirmColor, size: 24),
              const SizedBox(width: 10),
            ],
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              cancelText,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return result ?? false;
  }

  /// Dialog de saisie de texte
  static Future<String?> showInputDialog({
    required String title,
    String? hintText,
    String? initialValue,
    String confirmText = 'Valider',
    String cancelText = 'Annuler',
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    final result = await Get.dialog<String>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            autofocus: true,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: Text(
              cancelText,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  Get.back(result: text);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  /// Dialog de suppression
  static Future<bool> showDeleteDialog({
    String title = 'Supprimer',
    String? itemName,
  }) {
    final message = itemName != null
        ? 'Voulez-vous vraiment supprimer "$itemName" ? '
            'Cette action est irréversible.'
        : 'Voulez-vous vraiment supprimer cet élément ? '
            'Cette action est irréversible.';

    return showConfirmDialog(
      title: title,
      message: message,
      confirmText: 'Supprimer',
      confirmColor: Colors.red,
      icon: Icons.delete_outline,
    );
  }

  /// Dialog de déconnexion
  static Future<bool> showLogoutDialog() {
    return showConfirmDialog(
      title: 'Déconnexion',
      message: 'Voulez-vous vraiment vous déconnecter ?',
      confirmText: 'Se déconnecter',
      confirmColor: Colors.red.shade700,
      icon: Icons.logout,
    );
  }

  // ═══════════════════════════════════════════════════════
  // LOADING OVERLAY
  // ═══════════════════════════════════════════════════════

  /// Afficher un loading overlay (bloque les interactions)
  static void showLoading({String? message}) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 24,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 60),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(strokeWidth: 3),
                if (message != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.none,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black45,
    );
  }

  /// Masquer le loading overlay
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  // ═══════════════════════════════════════════════════════
  // BOTTOM SHEET
  // ═══════════════════════════════════════════════════════

  /// Bottom sheet avec handle bar
  static Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    double? maxHeight,
  }) {
    return Get.bottomSheet<T>(
      Container(
        constraints: maxHeight != null
            ? BoxConstraints(maxHeight: maxHeight)
            : null,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
    );
  }

  /// Bottom sheet avec titre
  static Future<T?> showTitledBottomSheet<T>({
    required String title,
    required Widget child,
    bool isDismissible = true,
    List<Widget>? actions,
  }) {
    return showBottomSheet<T>(
      isDismissible: isDismissible,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (actions != null) ...actions,
                if (actions == null)
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey.shade500,
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Flexible(child: child),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // DATE / TIME PICKERS
  // ═══════════════════════════════════════════════════════

  /// Sélecteur de date
  static Future<DateTime?> pickDate({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return await showDatePicker(
      context: Get.context!,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate:
          lastDate ?? DateTime.now().add(const Duration(days: 365 * 3)),
      locale: const Locale('fr', 'FR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  /// Sélecteur d'heure
  static Future<TimeOfDay?> pickTime({
    TimeOfDay? initialTime,
  }) async {
    return await showTimePicker(
      context: Get.context!,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  /// Sélecteur date + heure combiné
  static Future<Map<String, dynamic>?> pickDateTime({
    DateTime? initialDate,
    TimeOfDay? initialTime,
  }) async {
    final date = await pickDate(initialDate: initialDate);
    if (date == null) return null;

    final time = await pickTime(initialTime: initialTime);

    return {
      'date': date,
      'time': time,
    };
  }

  // ═══════════════════════════════════════════════════════
  // UTILITAIRES TEXTE
  // ═══════════════════════════════════════════════════════

  /// Obtenir les initiales d'un nom → "Jean Dupont" → "JD"
  static String getInitials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  /// Tronquer un texte → "Lorem ipsum dolor..."
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Formater un pourcentage → "62.2%"
  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  /// Formater un nombre → "1 234"
  static String formatNumber(int number) {
    if (number < 1000) return number.toString();
    final str = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  /// Pluraliser un mot → "3 listes", "1 item"
  static String pluralize(int count, String singular, [String? plural]) {
    final p = plural ?? '${singular}s';
    return '$count ${count <= 1 ? singular : p}';
  }

  // ═══════════════════════════════════════════════════════
  // FOCUS
  // ═══════════════════════════════════════════════════════

  /// Retirer le focus du clavier
  static void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}