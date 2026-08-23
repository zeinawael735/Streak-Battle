import 'package:flutter/material.dart';

class UserRankTile extends StatelessWidget {
  final String rank;
  final String name;
  final String checkIns;
  final String points;
  bool isSticky;

   UserRankTile({
    super.key,
    required this.rank,
    required this.name,
    required this.checkIns,
    required this.points,
    this.isSticky=false
  });

  @override
  Widget build(BuildContext context) {
    final nameParts = name.trim().split(' ');
    final initials = nameParts.length > 1
        ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase()
        : (name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase());

    return Container(
      margin: const EdgeInsets.symmetric( vertical: 6 ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:isSticky?Color(0XFF150050): Color(0xFF1E1B2E),
        borderRadius: BorderRadius.circular(16),
        border:isSticky? Border.all(width: 1.5, color:  Color(0xFF610094)):Border.all(width: 1.5, color: const Color(0xFF746E79))
      ),
      child: Row(
        children: [

          Text(
            rank,
            style: const TextStyle(
              color: Colors.white,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '$checkIns check-ins',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),


          Text(
            '$points pts',
            style: const TextStyle(
              color: Color(0xFFB062FF),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}