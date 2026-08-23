import 'package:flutter/material.dart';

class BadgeModel {
  final String title;
  final bool isUnlocked;
  final double progress;
  final IconData icon;

  BadgeModel({
    required this.title,
    required this.isUnlocked,
    required this.progress,
    required this.icon,
  });
}
