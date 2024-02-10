import 'package:expenses_app/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _textController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedcategory = Category.food;
  DateTime? _selecteddate;

  void _presentdatepicker() async {
    final now = DateTime.now();
    final firstdate = DateTime(now.year - 1, now.month, now.day);

    final pickeddate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstdate,
        lastDate: now);
    setState(() {
      _selecteddate = pickeddate;
    });
  }

  void _submitExpenseData() {
    final enteredamount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredamount == null || enteredamount <= 0;
    if (_textController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selecteddate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('INVALID INPUT',
              style: Theme.of(context).textTheme.titleLarge),
          content: Text('Please make sure a valid parameters was Entered...',
              style: Theme.of(context).textTheme.titleLarge),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child:
                    Text('OKAY', style: Theme.of(context).textTheme.titleLarge))
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
          title: _textController.text,
          amount: enteredamount,
          date: _selecteddate!,
          category: _selectedcategory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardspace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          maxLength: 50,
                          style: Theme.of(context).textTheme.titleLarge,
                          decoration: InputDecoration(
                              label: Text(
                            'TITLE',
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          maxLength: 50,
                          style: Theme.of(context).textTheme.titleLarge,
                          decoration: InputDecoration(
                            prefixText: '\u{20B9}',
                            label: Text('AMOUNT',
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _textController,
                    maxLength: 50,
                    style: Theme.of(context).textTheme.titleLarge,
                    decoration: InputDecoration(
                        label: Text(
                      'TITLE',
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedcategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge)),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedcategory = value;
                          });
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
                          Text(
                              _selecteddate == null
                                  ? 'SELECT DATE'
                                  : formatter.format(_selecteddate!),
                              style: Theme.of(context).textTheme.titleLarge),
                          IconButton(
                            onPressed: _presentdatepicker,
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ],
                      ))
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          maxLength: 50,
                          style: Theme.of(context).textTheme.titleLarge,
                          decoration: InputDecoration(
                            prefixText: '\u{20B9}',
                            label: Text('AMOUNT',
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              _selecteddate == null
                                  ? 'SELECT DATE'
                                  : formatter.format(_selecteddate!),
                              style: Theme.of(context).textTheme.titleLarge),
                          IconButton(
                            onPressed: _presentdatepicker,
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ],
                      ))
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('CANCEL'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('SAVE EXPENSE'),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedcategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge)),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedcategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('CANCEL'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('SAVE EXPENSE'),
                      )
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
