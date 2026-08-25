import 'package:flutter/material.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';

abstract class AppDialogs {
  // Show a loading dialog
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                 CircularProgressIndicator(color: AppColorStyle.primaryViolet),
                 SizedBox(width: 16),
                Text(
                  'Loading...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
