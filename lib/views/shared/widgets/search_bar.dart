import 'package:flutter/material.dart';

class SmartSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool showFilterButton;
  final VoidCallback? onFilter;

  const SmartSearchBar({
    super.key,
    this.controller,
    this.hint = 'Rechercher...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.showFilterButton = false,
    this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Icon(Icons.search, size: 22, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
          if (controller != null &&
              controller!.text.isNotEmpty &&
              onClear != null)
            GestureDetector(
              onTap: onClear,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          if (showFilterButton)
            GestureDetector(
              onTap: onFilter,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.tune,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}