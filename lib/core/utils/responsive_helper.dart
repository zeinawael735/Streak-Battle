import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double _designWidth = 375;
  static const double _designHeight = 812;

  final double screenWidth;
  final double screenHeight;

  ResponsiveHelper(BuildContext context)
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;

  double w(double value) => value * (screenWidth / _designWidth);
  double h(double value) => value * (screenHeight / _designHeight);
  double sp(double value) => w(value);
}