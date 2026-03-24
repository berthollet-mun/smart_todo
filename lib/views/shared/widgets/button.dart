import 'package:flutter/material.dart';

enum SmartButtonType { primary, secondary, outline, text, danger }

class SmartButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final SmartButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double height;
  final double borderRadius;
  final double fontSize;

  const SmartButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = SmartButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height = 52,
    this.borderRadius = 12,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final button = switch (type) {
      SmartButtonType.primary => _buildElevated(
          bg: theme.primaryColor,
          fg: Colors.white,
        ),
      SmartButtonType.secondary => _buildElevated(
          bg: Colors.grey.shade200,
          fg: Colors.black87,
        ),
      SmartButtonType.outline => _buildOutlined(context),
      SmartButtonType.text => _buildText(context),
      SmartButtonType.danger => _buildElevated(
          bg: Colors.red.shade600,
          fg: Colors.white,
        ),
    };

    if (isFullWidth) {
      return SizedBox(width: double.infinity, height: height, child: button);
    }
    return SizedBox(height: height, child: button);
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Colors.white,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildElevated({required Color bg, required Color fg}) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildOutlined(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        side: BorderSide(color: Theme.of(context).primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildText(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: _buildChild(),
    );
  }
}