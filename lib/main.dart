import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/providers/auth_provider.dart';
import 'package:task/views/screens/client_screen.dart';
import 'package:task/views/screens/login_screen.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(authNotifierProvider);
    return MaterialApp(
      title: 'ByteSymphony Test',
      initialRoute: loggedIn ? '/clients' : '/login',
      routes: {
        '/login': (_) => LoginScreen(),
        '/clients': (_) => ClientsScreen(),
      },
    );
  }
}
