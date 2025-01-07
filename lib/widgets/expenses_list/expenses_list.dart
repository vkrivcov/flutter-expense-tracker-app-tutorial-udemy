import 'package:flutter/material.dart';

import '../../models/expense.dart';
import 'expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    // when you have a list of elements that can grow very large (e.g. 100s) ->
    // Column is not ideal (which would he typically chosen) because Column
    // so not all of them will be visible (invisible items are useless and
    // will hit performance)
    // ListView -> scrollable list (but using builder on how to create it) ->
    // that will make sure that items will be build when they are visible OR
    // just to become visible (essentially saving compute power)
    // itemCount -> how many list parameters must be passed => Flutter will know
    // how many items should be displayed here
    // NOTE: index is directly related to itemCount in the end i.e. if itemCount
    // is equal = 2 then functions would be called 2 times only
    // IMPORTANT: above is needed to improve performance of the app, as if there
    // is 1000s of different widgets in the list then we will only build what is
    // visible instead of all as it would happen in the Column widget
    return ListView.builder(
      itemCount: expenses.length,

      // Dismissible is a helper method that could be wrapped around the element
      // that could be removed i.e. swiped away (its also a very common pattern
      // IMPORTANT: for vast majority of widgets key is not needed (key is
      // essentially an identifier) but for Dismissible widget its required so
      // it knows what widget to remove while swiping
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),

        // its a good idea to wrap up colour change in a container as over there
        // we can easily set color
        // NOTE: error is a predefined colour that is available to us
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.65),

          // fine tuning from original Theme
          // NOTE: in the below reference we used to point to default schema AND
          // if we would switch to Dark theme that would not be available -> and
          // therefore crash the app with null pointer (reasons: in Dark mode its
          // actually null)
          // margin:EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          margin:EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),

        // we actually need to do some action when the expense is being removed
        // so we created a function that would actually remove the item from the
        // list -> in real life that would be some soft of an API call
        // NOTE: that function takes a direction which in our case does not
        // really play any role so we will just ignore it
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(
          expense: expenses[index],
        ),
      ),
    );
  }
}
