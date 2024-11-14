import 'package:credit_minder_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class EditText extends StatefulWidget {
  final String? label;
  final String text;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const EditText({
    super.key,
    required this.text,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.label,
  });

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  bool isEditing = false;
  void ToggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.label ?? "",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            decoration: const InputDecoration(
              hintText: null,
              border: OutlineInputBorder(),
            ),
            enabled: isEditing,
          ),
        ),
        IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit),
          onPressed: ToggleEdit,
        ),
      ],
    );
  }
}
