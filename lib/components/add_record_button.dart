import 'package:flutter/material.dart';

class AddRecordButton extends StatelessWidget {
  final Function()? onTap;
  const AddRecordButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.add,
              size: 40,
              color: Colors.green,
            ),
            const SizedBox(width: 10),
            Text(
              "Add New Record",
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
