import 'package:flutter/material.dart';

import 'package:task/core/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Template',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
