import 'package:flutter/material.dart';
// Import the AppTheme file for centralized theming.

Widget buildDropdown<T>({
  required BuildContext context,
  required String label,
  required T value,
  required List<T> items,
  required void Function(T?) onChanged,
  String? Function(T?)? validator,
}) {
  final theme = Theme.of(context);
  return SizedBox(
    width: 300,
    child: DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            item.toString(),
            style: theme.textTheme.bodyMedium,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    ),
  );
}
