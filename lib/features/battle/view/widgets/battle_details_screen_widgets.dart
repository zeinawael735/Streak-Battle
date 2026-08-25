import 'package:flutter/material.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';

import '../../../../core/theme/theme.dart';
import '../../../home/view/widgets/home_card.dart';

class Participant {
  final String initials;
  final String name;

  const Participant({required this.initials, required this.name});
}

class ParticipantsDialog {
  static void showParticipant(BuildContext context, Participant participant) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon:  Icon(Icons.close, color: Theme.of(context).textTheme.headlineSmall?.color),
                  ),
                ),

                const SizedBox(height: 10),

                ParticipantCircle(initials: participant.initials, size: 90),

                const SizedBox(height: 16),

                Text(
                  participant.name,
                  style: Theme.of(context).textTheme.headlineMedium//.w600 18
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showMoreParticipants(
    BuildContext context,
    List<Participant> participants,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon:  Icon(Icons.close, color:Theme.of(context).textTheme.headlineSmall?.color),
                  ),
                ),

                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: participants.length,
                    separatorBuilder: (_, __) {
                      return const SizedBox(height: 12);
                    },
                    itemBuilder: (context, index) {
                      final participant = participants[index];

                      return Row(
                        children: [
                          ParticipantCircle(
                            initials: participant.initials,
                            size: 48,
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Text(
                              participant.name,
                              style:  Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.normal)
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ParticipantCircle extends StatelessWidget {
  final String initials;
  final double size;

  const ParticipantCircle({
    super.key,
    required this.initials,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2E263F),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
class CheckedInCard extends StatelessWidget{
  const CheckedInCard({super.key, required this.name, required this.initials, required this.goal, required this.time});

  final String name;
  final String initials;
  final String goal;
  final String time;

  @override
  Widget build(BuildContext context) {
    return HomeCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 21,horizontal: 16),
          child: Row(
            children: [
              ParticipantCircle(initials: initials, size: 50,),
              const SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name checked in",
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$goal • $time",
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 35,)
            ],
          ),
        )
    );
  }
}
