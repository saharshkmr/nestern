import 'package:flutter/material.dart';

Widget buildTextField(
  BuildContext context,
  String label,
  TextEditingController controller,
  String? Function(String?)? validator,
  void Function(String?) onSaved, {
  IconData? icon,
  int maxLines = 1,
  bool isNumeric = false,
  bool isPassword = false,
  bool readOnly = false,
  void Function()? onTap,
  Widget? suffixIcon,
  bool obscure = false, // <-- Add this
  VoidCallback? toggleObscure, // <-- And this
}) {
  final theme = Theme.of(context);
  return SizedBox(
    width: double.infinity,
    child: TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.blue,
                ),
                onPressed: toggleObscure,
              )
            : suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      maxLines: maxLines,
      obscureText: isPassword ? obscure : false, // <-- Use obscure here
      validator: validator,
      onSaved: onSaved,
      readOnly: readOnly,
      onTap: onTap,
    ),
  );
}