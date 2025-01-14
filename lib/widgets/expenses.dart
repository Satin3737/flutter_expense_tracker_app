import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/models/expense.dart';
import 'package:flutter_expense_tracker_app/new_expense.dart';
import 'package:flutter_expense_tracker_app/widgets/chart/chart.dart';
import 'package:flutter_expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:flutter_expense_tracker_app/widgets/expenses_list/expenses_placeholder.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _expenses = [];

  void _addExpense(Expense expense) => setState(() => _expenses.add(expense));

  void _removeExpense(Expense expense) {
    final int index = _expenses.indexOf(expense);

    setState(() => _expenses.remove(expense));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => _expenses.insert(index, expense)),
        ),
      ),
    );
  }

  _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) => NewExpense(addExpense: _addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final Widget content = _expenses.isEmpty
        ? ExpensesPlaceholder()
        : ExpensesList(expenses: _expenses, removeExpense: _removeExpense);

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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: width < 600
            ? Column(
                spacing: 12,
                children: [
                  Chart(expenses: _expenses),
                  Expanded(child: content),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  Expanded(
                    child: Chart(expenses: _expenses),
                  ),
                  Expanded(child: content),
                ],
              ),
      ),
    );
  }
}
