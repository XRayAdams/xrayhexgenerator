import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed, // Changed to nullable
  });

  final String title;
  final IconData icon;
  final VoidCallback? onPressed; // Changed to nullable

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 4),
          Text(title),
        ],
      ),
    );
  }
}
