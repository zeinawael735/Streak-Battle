import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;

  const DotsIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentIndex == index ? 22 : 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? const Color(0xFFFFD700)
                : (isDark ? Colors.white24 : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}