# Login Screen High-Fidelity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the existing `LoginScreen` with a high-fidelity implementation matching Figma specifications, including custom gradients, shadows, and layout.

**Architecture:** Use `HookConsumerWidget` for the screen, decomposing it into focused private widgets for the logo, text fields, and primary button. Styling will be driven by explicit `BoxDecoration` and `TextStyle` to match Figma CSS exactly.

**Tech Stack:** Flutter, Hooks, Riverpod.

---

### Task 1: Create LogoWidget

**Files:**
- Create: `lib/features/auth/widgets/logo_widget.dart`

- [ ] **Step 1: Implement LogoWidget with gradient background**

```dart
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4285F4), Color(0xFF34A853)],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.mail,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/auth/widgets/logo_widget.dart
git commit -m "feat(auth): add LogoWidget with custom gradient"
```

### Task 2: Create CustomTextField

**Files:**
- Create: `lib/features/auth/widgets/custom_text_field.dart`

- [ ] **Step 1: Implement CustomTextField with Figma styling**

```dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.hintText,
    this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? hintText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF555555),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            textInputAction: textInputAction,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFFBBBBBB),
                fontSize: 16,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/auth/widgets/custom_text_field.dart
git commit -m "feat(auth): add CustomTextField with Figma styles"
```

### Task 3: Create PrimaryButton

**Files:**
- Create: `lib/features/auth/widgets/primary_button.dart`

- [ ] **Step 1: Implement PrimaryButton with gradient and shadow**

```dart
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 53,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: onPressed == null
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEA4335), Color(0xFFC5221F)],
              ),
        color: onPressed == null ? Colors.grey : null,
        boxShadow: onPressed == null
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFFEA4335).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/auth/widgets/primary_button.dart
git commit -m "feat(auth): add PrimaryButton with gradient and shadow"
```

### Task 4: Refactor LoginScreen

**Files:**
- Modify: `lib/features/auth/login_screen.dart`

- [ ] **Step 1: Update LoginScreen to use new widgets and layout**

```dart
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
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/auth/login_screen.dart
git commit -m "feat(auth): refactor LoginScreen with high-fidelity UI"
```

### Task 5: Verification

- [ ] **Step 1: Analyze files for errors**

Run: `dart analyze`
Expected: No errors or warnings.

- [ ] **Step 2: Run tests to ensure no regressions**

Run: `flutter test test/features/auth/`
Expected: All auth tests pass.
