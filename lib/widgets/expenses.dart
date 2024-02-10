import 'package:expenses_app/models/expense.dart';
import 'package:expenses_app/models/new_expense.dart';
import 'package:expenses_app/widgets/chart/chart.dart';
import 'package:expenses_app/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredexpenses = [];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      constraints: const BoxConstraints(
        maxWidth: double.maxFinite,
      ),
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredexpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseindex = _registeredexpenses.indexOf(expense);
    setState(() {
      _registeredexpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('EXPENSE DELETED'),
        action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              setState(() {
                _registeredexpenses.insert(expenseindex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget maincontent = Center(
        child: Text('NO EXPENSES FOUND TRY ADD SOME',
            style: Theme.of(context).textTheme.titleLarge));

    if (_registeredexpenses.isNotEmpty) {
      maincontent = ExpensesList(
        expenses: _registeredexpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('EXPENSE TRACKER'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredexpenses),
                Expanded(child: maincontent),
              ],
            )
          : Row(children: [
              Expanded(
                child: Chart(expenses: _registeredexpenses),
              ),
              Expanded(child: maincontent),
            ]),
    );
  }
}
