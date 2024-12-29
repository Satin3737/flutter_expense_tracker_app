import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/enum.dart';
import 'package:flutter_expense_tracker_app/models/expense.dart';
import 'package:flutter_expense_tracker_app/new_expense.dart';
import 'package:flutter_expense_tracker_app/widgets/expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _expenses = [
    Expense(
      title: 'Apple',
      amount: 99.99,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: 'Banana',
      amount: 50.5,
      date: DateTime.now(),
      category: Category.work,
    ),
  ];

  void _addExpense({
    title = String,
    amount = double,
    date = DateTime,
    category = Category,
  }) {
    final newExpense = Expense(
      title: title,
      amount: amount,
      date: date,
      category: category,
    );
    setState(() => _expenses.add(newExpense));
  }

  _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewExpense(addExpense: _addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddExpenseOverlay,
          ),
        ],
        title: const Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ExpensesList(expenses: _expenses),
          ),
        ],
      ),
    );
  }
}
