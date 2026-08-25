import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/app_routes.dart';
import '../../view_model/onboarding_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/dot_indicator.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  Future<void> _navigateToSignUp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.signUp);
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // ================= الخلفية المتوهجة الناعمة (مغلفة بـ IgnorePointer لعدم منع اللمس) =================
          IgnorePointer(
            child: Stack(
              children: [
                Positioned(
                  top: -50,
                  left: -50,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE8D5C4).withOpacity(isDark ? 0.15 : 0.45),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE8D5C4).withOpacity(isDark ? 0.2 : 0.5),
                          blurRadius: 90,
                          spreadRadius: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -20,
                  right: -60,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFF3C4).withOpacity(isDark ? 0.12 : 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFF3C4).withOpacity(isDark ? 0.18 : 0.55),
                          blurRadius: 80,
                          spreadRadius: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
          // =========================================================================================

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: theme.textTheme.headlineLarge?.color ?? Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 5,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingList.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return OnboardingPage(
                        item: onboardingList[index],
                        index: index,
                      );
                    },
                  ),
                ),

                DotsIndicator(
                  currentIndex: _currentIndex,
                  itemCount: onboardingList.length,
                ),
                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: CustomButton(
                    text: _currentIndex == onboardingList.length - 1 ? 'Get started' : 'Continue',
                    onPressed: () {
                      if (_currentIndex < onboardingList.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _navigateToSignUp();
                      }
                    },
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}