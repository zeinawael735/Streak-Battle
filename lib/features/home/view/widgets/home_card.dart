import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({super.key,required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF201F1F),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
