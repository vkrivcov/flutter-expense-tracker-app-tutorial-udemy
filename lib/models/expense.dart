import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

// treats kind of like string values but they are not strings
enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work
};

class Expense {
  // {} -> names parameters
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category
  }) : id = uuid.v4();
  // : id = is a initialise list i.e. set a default generated ui in this case
  // that is needed when there is no value is passed to the constructor etc.

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  // getter instead of getFormattedDate
  get formattedDate {
    return formatter.format(date);
  }
}

// class used to populate the chart
class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses
});

  // extra utility constructor (additional constructor)
  // : is an initializer list that would precalculate whatever we need
  // NOTE: alternatively I am sure its possible to get list of expenses for a
  // specific category in a different way
  // NOTE: honestly its confusing and there are better more manual ways that
  // are all more self-explanatory
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses.where((expense) => expense.category == category)
      .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      // in theory over there we need to check for expense category, but with
      // the above constructor its all filtered out already
      sum += expense.amount;
    }
    return sum;
  }
}
