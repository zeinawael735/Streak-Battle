import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constants/app_color_style.dart';
import '../../../../core/routes/app_routes.dart';
import 'home_card.dart';

class NextUpCard extends StatelessWidget {
  const NextUpCard({
    super.key,
    required this.icon,
    required this.goal,
    required this.battleId,
    required this.participantsCount,
  });

  final IconData  icon;
  final String goal;
  final String battleId;
  final int participantsCount;

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
              decoration:  BoxDecoration(
                color: Theme.of(context).colorScheme.scrim,
                shape: BoxShape.circle,
              ),
              child: Center(
                child:Icon(icon, size: 22 /**/,),//dark;
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
                    style:  Theme.of(context).textTheme.headlineSmall
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Due today • $participantsCount players",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13)
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.checkIn, arguments: battleId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: AppColorStyle.primaryText,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text("Check in", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}