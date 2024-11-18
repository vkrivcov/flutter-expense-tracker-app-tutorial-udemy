import 'package:flutter/material.dart';

// exposes extra functionality like restricting orientation
// NOTE: only used as an example
// import 'package:flutter/services.dart';
import 'package:expense_tracker/widgets/expenses.dart';

// RECOMMEND: automatically create range of colours based on one base
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

// setting for dark colour scheme
var kDarkColorScheme = ColorScheme.fromSeed(
    // optimised for dark mode
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 5, 99, 125));

void main() {
  // IMPORTANT: restrict to portrait mode only if we want to
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
  //   (fn) {
  runApp(
    MaterialApp(
      // same as below -> here we are specifying that theme colour range for
      // dark schema (that is also very popular)
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,

        // need an explicit copy here as some of the elements reference that
        // in the next
        cardTheme: const CardTheme().copyWith(
          // IMPORTANT: is is also important to change the dark scheme
          // int other elements too
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          // to add to the above styleFrom is recommended here for buttons
          style: ElevatedButton.styleFrom(
              foregroundColor: kColorScheme.onPrimaryContainer,
              backgroundColor: kDarkColorScheme.primaryContainer),
        ),
      ),

      // instead of setting/creating your own scheme its better to use existing
      // one and they override anything there
      theme: ThemeData().copyWith(
        // the best and easiest approach instead of setting bunch of colours
        // individually, flutter does the rest for other elements
        colorScheme: kColorScheme,

        // copyWidth -> setting default settings + overriding other components
        // NOTE: that's the approach we always want to take i.e. copy default
        // settings and then add your own
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,

            // IMPORTANT: takes preference i.e. override
            foregroundColor: kColorScheme.primaryContainer),

        // used for expenses
        cardTheme: const CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

        // this one does not have copyWith, but there are not too many params
        // NOTE: but styleFrom will take all the default styling properties
        elevatedButtonTheme: ElevatedButtonThemeData(
          // to add to the above styleFrom is recommended here for buttons
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer),
        ),

        // NOTE: next theme looks slightly different
        textTheme: ThemeData().textTheme.copyWith(
              // title large would be set in multiple elements by default such as
              // appBar etc.
              titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kColorScheme.onSecondaryContainer,
                  fontSize: 16),
            ),
      ),
      // set a theme mode
      // themeMode: ThemeMode.system,  // default
      home: const Expenses(),
    ),
  );
  //},
  //);
}
