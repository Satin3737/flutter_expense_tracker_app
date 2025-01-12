import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/enum.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final dateFormatter = DateFormat.yMd();

const categoryIcons = {
  Category.food: Icons.fastfood,
  Category.work: Icons.work,
  Category.leisure: Icons.movie,
  Category.travel: Icons.flight_takeoff,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  IconData get iconData => categoryIcons[category]!;
  String get formatedDate => dateFormatter.format(date);
}

class ExpenseBucket {
  const ExpenseBucket({required this.expenses, required this.category});

  ExpenseBucket.forCategory(List<Expense> expenses, this.category)
      : expenses =
            expenses.where((expense) => expense.category == category).toList();

  final Category category;
  final List<Expense> expenses;

  get totalExpenses =>
      expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
//
// static ExpenseBucket forCategory(List<Expense> expenses, Category category) {
//   return expenses
//       .where((expense) => expense.category == category)
//       .fold<double>(0, (prev, element) => prev + element.amount);
// }
}
