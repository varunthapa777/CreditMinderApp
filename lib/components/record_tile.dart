import 'package:flutter/material.dart';

class RecordTile extends StatelessWidget {
  final String name;
  final String amount;
  final bool settled;
  final bool dueDateReached;
  Function()? onPressed;

  RecordTile(
      {super.key,
      required this.name,
      required this.amount,
      required this.settled,
      this.onPressed,
      required this.dueDateReached});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
          color: dueDateReached
              ? Colors.red.shade200
              : (settled
                  ? Colors.green.shade200
                  : Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: double.tryParse(amount) == 0
              ? const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 5),
                    Text("Amount Settled"),
                  ],
                )
              : Text('Amount: $amount'),
          trailing: settled
              ? const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                )
              : Icon(Icons.delete_forever,
                  color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
