import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_assets.dart';

class OnboardingCardOne extends StatelessWidget {
  const OnboardingCardOne({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF201F1F) : Colors.white;
    final circleBorderColor = const Color(0xFF7911FF).withOpacity(0.15);

    return Container(
      width: 340,
      height: 340,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.grey.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: circleBorderColor, width: 1.2),
            ),
          ),
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: circleBorderColor, width: 1.2),
            ),
          ),

          // مركز السيف المتوهج
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                  blurRadius: 25,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: SvgPicture.asset(
              AppAssets.battlesIconSvg,
              color: Colors.white,
              width: 36,
              height: 36,
            ),//const Icon(Icons.shield, color: Colors.white, size: 36),
          ),

          // badge الباتل
          Positioned(
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.check, color: Colors.white, size: 14),
                  SizedBox(width: 6),
                  Text(
                    "New battle ready",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingCardTwo extends StatelessWidget {
  const OnboardingCardTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF201F1F) : Colors.white;
    final circleBorderColor = const Color(0xFF7911FF).withOpacity(0.15);

    return Container(
      width: 340,
      height: 340,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.grey.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الدوائر الدائرية
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: circleBorderColor, width: 1.2),
            ),
          ),
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: circleBorderColor, width: 1.2),
            ),
          ),

          // أيقونة النار في الأعلى
          const Positioned(
            top: 65,
            right: 60,
            child: Icon(Icons.local_fire_department, color: Colors.amber, size: 28),
          ),

          // الأفاتارات الثلاثة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAvatar("MI", const Color(0xFF333042)),
              Transform.scale(
                scale: 1.2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: _buildAvatar("AM", Theme.of(context).primaryColor),
                ),
              ),
              _buildAvatar("NJ", const Color(0xFF333042)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String text, Color bg) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: bg,
      child: Text(
        text,
        style: TextStyle(
          color:  Colors.white ,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
class OnboardingCardThree extends StatelessWidget {
  const OnboardingCardThree({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF201F1F) : Colors.white;

    return Container(
      width: 340,
      height: 340,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.grey.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // دائرية خلفية ناعمة
          Container(
            width: 290,
            height: 290,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF7911FF).withOpacity(0.1), width: 1.2),
            ),
          ),

          // أعمدة الإحصائيات (Leaderboard Bars)
          Positioned(
            bottom: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(60, isDark ? const Color(0xFF2C283B) : Colors.grey.shade300),
                const SizedBox(width: 8),
                _buildBar(90, isDark ? const Color(0xFF38334A) : Colors.grey.shade400),
                const SizedBox(width: 8),

                // العمود المتوهج الرئيسي في المنتصف
                Container(
                  width: 50,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7911FF).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildBar(90, isDark ? const Color(0xFF38334A) : Colors.grey.shade400),
                const SizedBox(width: 8),
                _buildBar(60, isDark ? const Color(0xFF2C283B) : Colors.grey.shade300),
              ],
            ),
          ),

          // النجمة فوق العمود الرئيسي
          Positioned(
            top: 65,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: 37,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}