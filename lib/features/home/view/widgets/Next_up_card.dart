import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_color_style.dart';
import '../../../../core/routes/app_routes.dart';
import 'home_card.dart';

class NextUpCard extends StatelessWidget {
  const NextUpCard({super.key, required this.icon, required this.goal});

  final String icon;
  final String goal;

  @override
  Widget build(BuildContext context) {
    return HomeCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFF353534),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(icon, width: 22, height: 22),
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    goal,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Due today • 6 friends",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColorStyle.primaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.checkIn);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorStyle.primaryViolet,
                foregroundColor: AppColorStyle.primaryText,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                "Check in",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
