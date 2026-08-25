import 'package:flutter/material.dart';

class RedButton extends StatelessWidget {
  final VoidCallback onTap;
  String text;
  IconData? icon;
  Color borderColor;
  Color iconColor;
  RedButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
    required this.borderColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
