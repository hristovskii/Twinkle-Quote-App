import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Twinkle ',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              fontSize: 32,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          TextSpan(
            text: 'Quote',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              fontSize: 32,
              color: const Color(0xFF60A5FA),
            ),
          ),
        ],
      ),
    );
  }
}
