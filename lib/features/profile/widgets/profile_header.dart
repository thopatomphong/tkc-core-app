import 'package:core_app/models/profile.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final Profile user;

  @override
  Widget build(BuildContext context) {
    final initials =
        (user.displayName ?? user.username).substring(0, 1).toUpperCase() +
        (user.id.toString().substring(0, 1)); // Mocking "U1" style

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFD32F2F),
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName ?? user.username,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('@${user.username}', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(user.email, style: const TextStyle(color: Colors.blue)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: Colors.green, size: 8),
                SizedBox(width: 8),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
