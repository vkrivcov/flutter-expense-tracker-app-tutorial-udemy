import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    // mainly used for styling
    // NOTE: container like widget that provides a material design card UI to
    // easier group some of the elements together
    // NOTE: Card is a widget that provides a nice shadow and rounded corners
    // but its slightly heavier than Container (which is a more basic widget)
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

        // we only have 2 or so rows here hence no need for ListView (fixed)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // we can access global Theme
            Text(expense.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Row(
              children: [
                // toStringAsFixed -> will ensure that we will round any amount
                // to a fixed value i.g. 12.3456 => 12.34
                // otherwise would need to round double and then convert it to
                // string which is just way too cumbersome
                Text('\$${expense.amount.toStringAsFixed(2)}'),

                // spacer will automatically take ALL remaining space that is
                // left IN THE ROW after putting elements to the right (as we
                // are dealing with Rows here elements are positioned | | | |
                // in other case we would have to push elements somehow to the
                // right and deal with any potential overflows
                const Spacer(),

                // we want to "group" category and date together but they need
                // to be pushed in different directions of the Row
                Row(children: [
                  Icon(categoryIcons[expense.category]),
                  const SizedBox(width: 8),
                  Text(expense.formattedDate)
                ])
              ],
            )
          ],
        ),
      ),
    );
  }
}
