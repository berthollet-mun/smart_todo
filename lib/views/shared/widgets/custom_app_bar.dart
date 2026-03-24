import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? leading;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;
  final Widget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
    this.onBack,
    this.leading,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 0,
    this.bottom,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        bottom != null ? kToolbarHeight + 48 : kToolbarHeight,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation,
      scrolledUnderElevation: 0,
      leading: leading ??
          (showBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                )
              : null),
      automaticallyImplyLeading: showBack,
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: bottom!,
            )
          : null,
    );
  }
}