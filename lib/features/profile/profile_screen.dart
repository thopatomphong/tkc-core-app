import 'package:core_app/features/auth/auth_controller.dart';
import 'package:core_app/features/profile/profile_providers.dart';
import 'package:core_app/features/profile/widgets/profile_header.dart';
import 'package:core_app/features/profile/widgets/profile_section.dart';
import 'package:core_app/features/profile/widgets/profile_tile.dart';
import 'package:core_app/features/profile/widgets/sign_out_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F9),
      body: SafeArea(
        child: profile.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('$error')),
          data: (user) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    'Profile',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                ProfileSection(children: [ProfileHeader(user: user)]),
                ProfileSection(
                  label: 'ACCOUNT',
                  children: [
                    ProfileTile(
                      icon: Icons.person,
                      iconColor: const Color(0xFF1E88E5),
                      title: 'Display Name',
                      value: user.displayName ?? user.username,
                    ),
                    const Divider(height: 1, indent: 64),
                    ProfileTile(
                      icon: Icons.email,
                      iconColor: const Color(0xFF43A047),
                      title: 'Email',
                      value: user.email,
                    ),
                  ],
                ),
                ProfileSection(
                  label: 'NOTIFICATIONS',
                  children: [
                    const ProfileTile(
                      icon: Icons.notifications,
                      iconColor: Color(0xFFFFB300),
                      title: 'Push Notifications',
                      value: 'Enabled',
                    ),
                    const Divider(height: 1, indent: 64),
                    const ProfileTile(
                      icon: Icons.notifications_active,
                      iconColor: Color(0xFF1E88E5),
                      title: 'WebSocket',
                      value: 'Connected',
                    ),
                  ],
                ),
                SignOutButton(
                  onTap: () =>
                      ref.read(authControllerProvider.notifier).logout(),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
