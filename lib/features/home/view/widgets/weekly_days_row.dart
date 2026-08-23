import 'package:flutter/material.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';

class WeeklyDaysRow extends StatelessWidget {
  const WeeklyDaysRow({
    super.key,
    required this.completedDays,
    required this.currentDayIndex ,
  });
  final List<bool> completedDays;

  final int currentDayIndex;

  @override
  Widget build(BuildContext context) {
    const days = [ 'S', 'S','M', 'T', 'W', 'T', 'F'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        bool isComplete = index < completedDays.length ? completedDays[index] : false;
        bool isToday = index+1 == currentDayIndex;

        return buildDayCircle(
          label: days[index],
          isComplete: isComplete,
          isToday: isToday,
          context: context,
        );
      }),
    );
  }

  Widget buildDayCircle({
    required BuildContext context,
    required String label,
    required bool isComplete,
    required bool isToday,
  }) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isComplete ? Theme.of(context).colorScheme.primary : Colors.transparent,
            border: Border.all(
              color: isToday
                  ? const Color(0xFFFFD700)
                  : (isComplete ? Colors.transparent : Theme.of(context).colorScheme.surfaceBright.withOpacity(0.1)),
              width: isToday ? 2 : 1,
            ),
            boxShadow: isToday
                ? [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              )
            ]
                : null,
          ),
          child: isComplete
              ? const Icon(
            Icons.check,
            color: Colors.white,
            size: 20,
          )
              : null,
        ),
        const SizedBox(height: 8),

        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isToday
                ?  Color(0xFFFFD700)
                : (isComplete ? Theme.of(context).textTheme.bodySmall?.color : Colors.grey[600]),
            fontWeight: (isComplete || isToday) ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}