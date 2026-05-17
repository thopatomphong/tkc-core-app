import 'package:core_app/features/auth/auth_controller.dart';
import 'package:core_app/features/auth/widgets/custom_text_field.dart';
import 'package:core_app/features/auth/widgets/logo_widget.dart';
import 'package:core_app/features/auth/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = useTextEditingController(text: 'user1');
    final password = useTextEditingController(text: 'password');
    final auth = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      next.whenData((loggedIn) {
        if (loggedIn && context.mounted) context.go('/');
      });
    });

    Future<void> submit() async {
      await ref
          .read(authControllerProvider.notifier)
          .login(username.text.trim(), password.text);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 393),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const LogoWidget(),
                  const SizedBox(height: 20),
                  const Text(
                    'Mock Mail',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mail Service & Mini Apps',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 80),
                  CustomTextField(
                    label: 'Username',
                    controller: username,
                    hintText: 'user1',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Password',
                    controller: password,
                    obscureText: true,
                    hintText: '••••••••',
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => submit(),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    onPressed: auth.isLoading ? null : submit,
                    text: 'Sign In',
                    isLoading: auth.isLoading,
                  ),
                  if (auth.hasError) ...[
                    const SizedBox(height: 16),
                    Text(
                      '${auth.error}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
