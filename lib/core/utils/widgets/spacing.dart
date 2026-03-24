import 'package:flutter/material.dart';

/// Raccourcis pour les espacements verticaux et horizontaux
class Spacing {
  Spacing._();

  // ─── VERTICAL ─────────────────────────────────────────
  static const Widget v4 = SizedBox(height: 4);
  static const Widget v8 = SizedBox(height: 8);
  static const Widget v12 = SizedBox(height: 12);
  static const Widget v16 = SizedBox(height: 16);
  static const Widget v20 = SizedBox(height: 20);
  static const Widget v24 = SizedBox(height: 24);
  static const Widget v32 = SizedBox(height: 32);
  static const Widget v40 = SizedBox(height: 40);
  static const Widget v48 = SizedBox(height: 48);

  // ─── HORIZONTAL ───────────────────────────────────────
  static const Widget h4 = SizedBox(width: 4);
  static const Widget h8 = SizedBox(width: 8);
  static const Widget h12 = SizedBox(width: 12);
  static const Widget h16 = SizedBox(width: 16);
  static const Widget h20 = SizedBox(width: 20);
  static const Widget h24 = SizedBox(width: 24);
  static const Widget h32 = SizedBox(width: 32);

  // ─── CUSTOM ───────────────────────────────────────────
  static Widget vertical(double height) => SizedBox(height: height);
  static Widget horizontal(double width) => SizedBox(width: width);

  // ─── DIVIDERS ─────────────────────────────────────────
  static Widget divider({
    double height = 1,
    Color? color,
    double indent = 0,
    double endIndent = 0,
  }) {
    return Divider(
      height: height,
      thickness: height,
      color: color ?? Colors.grey.shade200,
      indent: indent,
      endIndent: endIndent,
    );
  }

  static Widget dividerWithPadding({
    double verticalPadding = 8,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: divider(color: color),
    );
  }
}