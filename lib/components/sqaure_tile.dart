import 'package:flutter/material.dart';

class SqaureTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const SqaureTile({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white),
        ),
        padding: const EdgeInsets.all(20),
        child: Image.asset(
          imagePath,
          height: 40,
        ),
      ),
    );
  }
}
