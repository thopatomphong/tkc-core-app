import 'package:core_app/features/auth/auth_controller.dart';
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
      appBar: AppBar(title: const Text('TKC Mail')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Text(
                'Sign in',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: username,
                decoration: const InputDecoration(labelText: 'Username'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSubmitted: (_) => submit(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: auth.isLoading ? null : submit,
                child: auth.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
              if (auth.hasError) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  '${auth.error}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
