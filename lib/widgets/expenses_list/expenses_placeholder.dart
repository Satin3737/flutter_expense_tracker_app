import 'package:flutter/material.dart';

class ExpensesPlaceholder extends StatelessWidget {
  const ExpensesPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No expenses added yet.',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
