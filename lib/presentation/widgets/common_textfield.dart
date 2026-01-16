import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}