import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker_app/enum.dart';
import 'package:flutter_expense_tracker_app/helper.dart';
import 'package:flutter_expense_tracker_app/models/expense.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});

  final void Function(Expense expense) addExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
    );

    setState(() => _selectedDate = pickedDate);
  }

  void _selectCategory(Category? category) {
    setState(() {
      if (category != null) {
        _selectedCategory = category;
      }
    });
  }

  void _submitExpense() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text);
    final amountInvalid = amount == null || amount <= 0;

    if (title.isEmpty || amountInvalid || _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please enter a valid title and amount.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    widget.addExpense(
      Expense(
        title: title,
        amount: amount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );

    Navigator.pop(context);
  }

  void _closeOverlay() => Navigator.pop(context);

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 24, 16, keyboardSpace + 24),
          child: Column(
            spacing: 48,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                spacing: 16,
                children: [
                  if (width > 600)
                    Row(
                      spacing: 24,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              prefixText: '\$ ',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      spacing: 16,
                      children: [
                        TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            prefixText: '\$ ',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  Row(
                    spacing: 24,
                    children: [
                      Expanded(
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(8),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                      capitalizeFirstLetter(category.name)),
                                ),
                              )
                              .toList(),
                          onChanged: _selectCategory,
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: _presentDatePicker,
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          icon: const Icon(
                            Icons.calendar_month,
                            size: 24,
                          ),
                          label: Text(
                            _selectedDate == null
                                ? 'No Date Chosen'
                                : formatter.format(_selectedDate!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _closeOverlay,
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: _submitExpense,
                    child: const Text('Add Expense'),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
