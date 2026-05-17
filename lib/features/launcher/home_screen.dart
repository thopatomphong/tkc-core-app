import 'package:core_app/features/launcher/widgets/home_header.dart';
import 'package:core_app/features/launcher/widgets/mini_app_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(onAvatarTap: () => context.go('/profile')),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Mini Apps',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  MiniAppCard(
                    title: 'Shopping',
                    description: 'Browse & order products',
                    icon: Icons.shopping_bag_outlined,
                    iconColor: const Color(0xFF1E88E5),
                    onTap: () => context.go('/shopping'),
                  ),
                  MiniAppCard(
                    title: 'Concert',
                    description: 'Book concert tickets',
                    icon: Icons.confirmation_num_outlined,
                    iconColor: const Color(0xFFFFB300),
                    onTap: () => context.go('/concert'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
