import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constants/app_color_style.dart';

class NavIcon extends StatelessWidget {
  const NavIcon({
    super.key,
    required this.path,
    required this.index,
    required this.currentIndex,
    required this.label,
  });

  final String path;
  final int index;
  final int currentIndex;
  final String label;

  @override
  Widget build(BuildContext context) {
    final Map<int, int> screenToNav = {
      0: 0,
      1: 1,
      2: 3,
      3: 4,
    };

    final navIndex = screenToNav[currentIndex] ?? 0;
    final isActive = navIndex == index;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          path,
          height: 24,
          width: 24,
          colorFilter: ColorFilter.mode(
            isActive ? AppColorStyle.primaryViolet : AppColorStyle.inactiveGrey,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: isActive ? 15 : 12,
            color: isActive ? AppColorStyle.primaryViolet : AppColorStyle.inactiveGrey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}