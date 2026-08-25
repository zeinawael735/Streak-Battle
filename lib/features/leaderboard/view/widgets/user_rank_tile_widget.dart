import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserRankTile extends StatelessWidget {
  final String rank;
  final String name;
  final String checkIns;
  final String points;
  final bool isSticky;

  const UserRankTile({
    super.key,
    required this.rank,
    required this.name,
    required this.checkIns,
    required this.points,
    this.isSticky = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final nameParts = name.trim().split(' ');
    final initials = nameParts.length > 1
        ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase()
        : (name.length >= 2
            ? name.substring(0, 2).toUpperCase()
            : name.toUpperCase());

    final cardBgColor = isSticky
        ? (isDark ? const Color(0XFF150050) : const Color(0xFFE5D4F0))
        : (isDark ? const Color(0xFF1E1B2E) : const Color(0xFFF3EBF7));

    final borderColor = isSticky
        ? (isDark ? const Color(0xFF610094) : const Color(0xFF7911FF))
        : (isDark ? const Color(0xFF746E79) : const Color(0xFFD6C8E0));

    final textColor = isDark ? Colors.white : const Color(0xFF16151A);
    final subTextColor = isDark ? Colors.white38 : Colors.grey[600];
    final pointsColor =
        isDark ? const Color(0xFFB062FF) : const Color(0xFF7911FF);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1.5, color: borderColor),
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: const Color(0xFF610094),
            radius: 18,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '$checkIns check-ins',
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$points pts',
            style: TextStyle(
              color: pointsColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
