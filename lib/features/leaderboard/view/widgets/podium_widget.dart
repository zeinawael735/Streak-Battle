import 'package:flutter/material.dart';
import 'package:streak_battle/features/leaderboard/view_model/user_model.dart';

class PodiumWidget extends StatelessWidget {
  final List<UserModel> top3;

  const PodiumWidget({
    super.key,
    required this.top3,
  });

  @override
  Widget build(BuildContext context) {

    final UserModel? first = top3.isNotEmpty ? top3[0] : null;
    final UserModel? second = top3.length > 1 ? top3[1] : null;
    final UserModel? third = top3.length > 2 ? top3[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        if (second != null)
          _buildPodiumItem(
            rank: "2",
            user: second,
            height: 100,
            color: const Color(0XFF610094),
          )
        else
          const SizedBox(width: 100),


        if (first != null)
          _buildPodiumItem(
            rank: "1",
            user: first,
            height: 140,
            color: const Color(0XFF3F0071),
          )
        else
          const SizedBox(width: 100),


        if (third != null)
          _buildPodiumItem(
            rank: "3",
            user: third,
            height: 70,
            color:  Color(0XFF0E0D12),
          )
        else
          const SizedBox(width: 100),
      ],
    );
  }


  String getInitials(String name) {
    if (name.trim().isEmpty) return "";
    final parts = name.trim().split(' ');
    if (parts.length > 1 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  Widget _buildPodiumItem({
    required String rank,
    required UserModel user,
    required double height,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        CircleAvatar(
          radius: 45,
          backgroundColor: const Color(0XFF150050),
          child: Text(
            getInitials(user.displayName),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),


        Container(
          height: height,
          width: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                rank,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}