import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final IconData? icon;
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  const MyTextfield({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      ),
    );
  }
}
