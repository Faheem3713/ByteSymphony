import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/core/widgets/celevated_button.dart';
import 'package:task/core/widgets/ctext_field.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                CtextField(controller: emailController, labelText: 'Email'),
                const SizedBox(height: 16),
                CtextField(
                  controller: passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                CelevatedButton(
                  text: 'Login',
                  isLoading: loginState.isLoading,
                  onPressed: () {
                    ref
                        .read(loginProvider.notifier)
                        .login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
