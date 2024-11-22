import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

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
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  void _openAddExpenseOverlay() {
    // show..gives quite a bit of options (build in)
    // note: context is a globally available in class that has state
    showModalBottomSheet(
      // making sure that we are staying away from safe areas like system bar
      // on top
      // NOTE: in most cases its not needed but (like Scaffold that takes care
      // of it automatically) but its a useful feature to know especially for
      // Modals) -> that eliminates things like guessing the padding in other
      // components that might be wrapping up this Modal view).
      useSafeArea: true,

      // by setting it -> modal will take ALL available space so keyboard
      // inputs wont obscure the view of edit fields
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(addExpense: _addExpense),
    );
  }

  void _addExpense(Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  // functionality is needed to actual remove an expanse from the list of
  // expenses when we actually swipe the actual expense card view
  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    // that might be a very useful feature if we remove multiple items AND if
    // there is a delay removing them they will keep appearing therefore if
    // any item being removed and existing snack bar is displayed we just want
    // to remove it immediately AND don't wait for the delay
    ScaffoldMessenger.of(context).clearSnackBars();

    // another amazing idea to show and hide some messages -> it has quite a bit
    // of options to show things on the interface
    // snack bar is the info message at the bottom of the screen
    ScaffoldMessenger.of(context).showSnackBar(
        // NOTE: in majority of cases SnackBar content widget will be some soft
        // of text
        // other settings control duration of for how long its being pressed etc.
        SnackBar(
            content: const Text('Expense deleted.'),
            duration: const Duration(seconds: 5),

            // this is essentially an action button in the snack bar that we can
            // control and assign any actions to it
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _registeredExpenses.insert(expenseIndex, expense);
                });
              },
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    // if list is empty not empty then show it, otherwise show default widget
    // above that would be set to the main content already
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      // more "official" way to place an app bar as in theory it would be placed
      // anywhere i.e. in any children
      // NOTE: appBar will also push things down and will reserve the space for
      // camera and other bits to its actual use (before we would have to push
      // it down with other widgets etc.)
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          // just an icon button (quite popular option)
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),

      // NOTE: dealing with different screen sizes and rotates
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),

                // IMPORTANT: expanded is needed when we are dealing with lists within
                // the list as in our case Column is a list and then we are asking
                // to render a ListView which is another list -> it simply does not
                // know how to size the column
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                // NOTE: for responsive add also wrap up a chart (that
                // is set up to take double.infinity as a width inside it) ->
                // here we are restricting it to take as much space that is only
                // detected by its parent)
                // IMPORTANT: is a used solution when widgets don't work well
                // together
                // Chart(expenses: _registeredExpenses),
                Expanded(child: Chart(expenses: _registeredExpenses)),

                // IMPORTANT: expanded is needed when we are dealing with lists within
                // the list as in our case Column is a list and then we are asking
                // to render a ListView which is another list -> it simply does not
                // know how to size the column
                // IMPORTANT 2: ListView inside the chard by default does not
                // have any height constrains (so can go forever) therefore it
                // usually need to be wrapped up with some widget that has size
                // constrains hence for how we wrapped it up (kind of confusing
                // buts that's how it works)
                // Expanded: sets as much height as it can get so essentially it
                // restricts therefore it's important to wrap it inside
                // unconstrained widgets
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
