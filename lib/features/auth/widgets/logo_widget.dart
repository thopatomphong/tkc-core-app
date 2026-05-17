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
