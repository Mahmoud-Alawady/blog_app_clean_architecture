import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool obsecureText;
  final bool readOnly;
  final VoidCallback? onTap;

  const AuthField({
    required this.hint,
    this.controller,
    this.onTap,
    this.obsecureText = false,
    this.readOnly = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(hintText: hint),
      obscureText: obsecureText,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return '$hint is missing!';
        } else {
          return null;
        }
      },
    );
  }
}
