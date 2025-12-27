import 'package:flutter/material.dart';
import 'package:gaia/routes/index.dart';
import 'package:gaia/theme/index.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'GAIA', theme: theme, routes: routes);
  }
}
