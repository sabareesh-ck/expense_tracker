import 'dart:io';

import 'package:expense_tracker/widgets/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense(this.OnAddExpense, {super.key});
  final void Function(Expense expense) OnAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selecteddate;
  Category _selectedCategory = Category.leisure;
  void submitExpense() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selecteddate == null) {
      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text("Invaid Input"),
            content: const Text(
                "Please make sure a valid Title, Amount and Date was entered"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text("OK"))
            ],
          ),
        );
        return;
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Invaid Input"),
            content: const Text(
                "Please make sure a valid Title, Amount and Date was entered"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text("OK"))
            ],
          ),
        );
        return;
      }
    } else {
      widget.OnAddExpense(Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selecteddate!,
          category: _selectedCategory));
      Navigator.pop(context);
    }
  }

  void _presentDataPicked() async {
    final now = DateTime.now();
    final firstdate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstdate,
        lastDate: now);
    setState(() {
      _selecteddate = pickedDate;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }
  /*var _enteredTitle = ' ';

  void _saveTitleInput(String inputValue) {
    _enteredTitle = inputValue;
  }*/

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: 16, top: 16, right: 14, bottom: keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: InputDecoration(
                              label: const Text("Title"),
                              suffixIcon: Camera(
                                OnAddExpense: widget.OnAddExpense,
                              )),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: InputDecoration(
                      label: const Text("Title"),
                      suffixIcon: Camera(
                        OnAddExpense: widget.OnAddExpense,
                      ),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(
                            () {
                              if (value == null) {
                                return;
                              }
                              _selectedCategory = value;
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selecteddate == null
                                ? "No Date Selected"
                                : formatter.format(_selecteddate!)),
                            IconButton(
                                onPressed: _presentDataPicked,
                                icon: const Icon(Icons.calendar_month))
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selecteddate == null
                                ? "No Date Selected"
                                : formatter.format(_selecteddate!)),
                            IconButton(
                                onPressed: _presentDataPicked,
                                icon: const Icon(Icons.calendar_month))
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                          onPressed: submitExpense,
                          child: const Text("Save Expense")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"))
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value == null) {
                                return;
                              }
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: submitExpense,
                          child: const Text("Save Expense")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"))
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
