import 'package:flutter/material.dart';

IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Fitness': return Icons.directions_run;
    case 'Learning': return Icons.menu_book;
    case 'Wellness': return Icons.self_improvement;
    case 'Nutrition': return Icons.apple;
    case 'Coding': return  Icons.code;
    default: return Icons.edit;
  }
}