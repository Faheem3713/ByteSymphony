import 'package:flutter/material.dart';

class CtextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CtextField({
    super.key,
    required this.controller,

    this.obscureText = false,
    required this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
