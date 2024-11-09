import 'package:flutter/material.dart';

class RecordTile extends StatelessWidget {
  final String name;
  final String amount;
  final bool settled;
  Function()? onPressed;

  RecordTile(
      {super.key,
      required this.name,
      required this.amount,
      required this.settled,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(name),
        subtitle: Text("Amount: $amount"),
        trailing: IconButton(
          icon: Icon(
            Icons.check_circle,
            color: settled ? Colors.green : Colors.grey,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
