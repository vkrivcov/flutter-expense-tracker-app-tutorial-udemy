import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

import 'dialog/success_dialog.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});

  final void Function(Expense) addExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  // linked to TextField inputs => one way of storing those values
  // var _enteredTitle = '';
  // void _saveTitleInput(String inoutValue) {
  //   _enteredTitle = inoutValue;
  // }

  // another approach => optimised user inout where flutter does all the heavy
  // lifting
  // IMPORTANT: that controller must be killed and removed from memory as it
  // will keep living even after Widget is being closed!
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    // another build method that is available in Flutter
    // async and await helps to deal with futures
    // await simply tells that it wont be available in the future so Flutter
    // essentially needs to wait
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    // one way of returning future method
    // .then((value) {});

    // NOTE: line here wont be executed until await function about would
    // actually return value
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    // double.tryParse will return double if valid or null if invalid
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid =
        (enteredAmount == null || enteredAmount <= 0) ? true : false;

    // default category is preselected already hence no need to add it to the check
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      // show error message
      // info / error dialogue etc.
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      // just to make sure that nothing else is executed as we will use further
      // function to return actual values
      return;
    }
    var newExpense = Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory);
    widget.addExpense(newExpense);

    // close this modal
    Navigator.pop(context);

    // just for fund showing (as extra) a new dialog with a confirmation
    showDialog(
      context: context,
      builder: (ctx) {
        return const SuccessDialog(
            dialogText: 'New expense added successfully');
      },
    );
  }

  @override
  void dispose() {
    // we explicitly tell Flutter that this controller is not needed anymore
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // viewInsets.bottom -> get your extra info overlapping UI elements from
    // the bottom -> this is what our original keyboard takes, so essentially
    // its getting constrains of a parent instead of just available sizes
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    // constrains object tell what constrains are applied by a parent object
    return LayoutBuilder(builder: (ctx, constrains) {
      final width = constrains.maxWidth;

      // we want to start with padding since don't want to sit on the edges of
      // that modal sheet
      return SizedBox(
        // tell it to get as much space as it can at all situations
        height: double.infinity,

        // wrap up so we can actually scroll it so we can reach to other elements
        // when keyboard pops up
        child: SingleChildScrollView(
          child: Padding(
            // set custom passing from Left, Top, Right, Bottom
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),

            // there will be multiple elements one beside another one hence Column
            child: Column(
              children: [
                // special syntax of using if else inside widget (no curly
                // braces)
                if (width >= 600)
                  Row(
                    // need to make sure that title and amount are off -> we
                    // to set vertical alignment to all would be pushed to the
                    // top
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ideally we would want to reuse that widget, for now its a
                      // direct copy from the below
                      Expanded(
                        child: TextField(
                          // one way of registering the text (i.e. each time value is stored
                          // as user type it out => BUT its not efficient as we essentially
                          // call that update function every time + you need to store those
                          // values everywhere in the code
                          // onChanged: _saveTitleInput,

                          // instead we will be using a controller
                          // NOTE: if have multiple fields then need to have a controller
                          // for each of them
                          controller: _titleController,

                          maxLength: 50,

                          // virtual keyboard (below is a default one)
                          keyboardType: TextInputType.text,

                          // IMPORTANT: that is a weird one but its actual label
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    // one way of registering the text (i.e. each time value is stored
                    // as user type it out => BUT its not efficient as we essentially
                    // call that update function every time + you need to store those
                    // values everywhere in the code
                    // onChanged: _saveTitleInput,

                    // instead we will be using a controller
                    // NOTE: if have multiple fields then need to have a controller
                    // for each of them
                    controller: _titleController,

                    maxLength: 50,

                    // virtual keyboard (below is a default one)
                    keyboardType: TextInputType.text,

                    // IMPORTANT: that is a weird one but its actual label
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                Row(
                  children: [
                    // NOTE: in not put inside Expanded then will have sizing issues
                    // as we've seen before
                    // REMEMBER: raw wants to take as much space as possible and Row
                    // would not restrict it
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$ ',
                          label: Text('Amount'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    // here we will create a little Data Picker
                    // NOTE: remember row within the row also needs to be wrapped with
                    // Expanded here
                    Expanded(
                      // IMPORTANT: had an overflow of 4.5pm before, changes that one
                      // to 0 (default is 1) and its fixed itself
                      // explanation: you are explicitly telling Flutter not to allow that widget
                      // to flexibly expand. Instead, it should only occupy the space
                      // required by its child widget, that is particularly useful
                      // when dealing with TextFields etc.
                      flex: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ! is essentially forces Flutter that value will not be null
                          Text(_selectedDate == null
                              ? 'No date selected'
                              : formatter.format(_selectedDate!)),
                          IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      // need to invoke map to transform each of the elements +
                      // use to list as we are dealing with lists here
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                              // value that will actually be displayed in onChanged
                              value: category,
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // another build in class -> it simply removes if from the
                        // screen
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Save Expense'),
                    ),
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
