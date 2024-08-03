import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/widgets.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _Expenses();
  }
}

class _Expenses extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter',
        amount: 99.9,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 200,
        date: DateTime.now(),
        category: Category.leisure)
  ];
  void AddExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Expense Deleted"),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  void _openAtExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(AddExpense);
        });
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    Widget MainContent = const Center(
      child: Text("No Expense Found,Start adding some!!"),
    );
    if (_registeredExpenses.isNotEmpty) {
      MainContent = ExpenseList(
        expenses: _registeredExpenses,
        onRemove: removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.topLeft,
          child: const Text(
            "Flutter Expenses Track",
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openAtExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < height
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: MainContent),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(child: MainContent),
              ],
            ),
    );
  }
}
