import 'package:flutter/material.dart';

final theme = ThemeData(
  listTileTheme: const ListTileThemeData(iconColor: Colors.black),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black, fontSize: 20),
    bodySmall: TextStyle(color: Colors.black, fontSize: 14),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
);
