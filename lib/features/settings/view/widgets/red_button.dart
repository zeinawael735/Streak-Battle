import 'package:flutter/material.dart';

class RedButton extends StatelessWidget {
  final VoidCallback onTap;
  String text;
  IconData? icon;
   RedButton({super.key, required this.onTap, required this.text,required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.redAccent.shade700, width: 1.5),
        ),
        child: Row(
          children: [
             Icon(icon, color: Colors.redAccent, size: 20),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}