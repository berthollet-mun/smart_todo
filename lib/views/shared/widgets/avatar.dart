import 'package:flutter/material.dart';

import '../../core/utils/helpers.dart';

class SmartAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final Color? backgroundColor;
  final double fontSize;

  const SmartAvatar({
    super.key,
    required this.name,
    this.radius = 20,
    this.backgroundColor,
    this.fontSize = 14,
  });

  Color _generateColor(String name) {
    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
      Colors.pink.shade400,
      Colors.indigo.shade400,
      Colors.cyan.shade400,
    ];
    final index = name.codeUnits.fold(0, (sum, c) => sum + c) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? _generateColor(name),
      child: Text(
        Helpers.getInitials(name),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
      ),
    );
  }
}