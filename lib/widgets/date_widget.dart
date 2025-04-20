import 'package:flutter/material.dart';
// Import the AppTheme file for consistent styling.

Widget buildDateField(
  BuildContext context,
  String label,
  TextEditingController controller,
  VoidCallback onTap, {
  String? Function(String?)? validator,
}) {
  final theme = Theme.of(context);
  return SizedBox(
    width: 300,
    child: TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        // Use the themed text style for labels.
        labelStyle: theme.textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // The suffix icon now uses the themed icon color.
        suffixIcon: Icon(
          Icons.calendar_today,
          color: theme.iconTheme.color,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      validator: validator,
      onTap: onTap,
    ),
  );
}
