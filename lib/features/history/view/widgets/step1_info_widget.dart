import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:streak_battle/features/history/view/widgets/custom_text_form_field.dart';

import '../../../../core/constants/app_assets.dart';

class Step2InfoWidget extends StatelessWidget {
  const Step2InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Battle Basics",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Give your challenge a clear, motivating identity"
                ,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "BATTLE NAME",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
         CustomTextFormField(
           prefixIcon: SvgPicture.asset(AppAssets.swordIconSvg),

         )

        ],
      ),
    );
  }
}
