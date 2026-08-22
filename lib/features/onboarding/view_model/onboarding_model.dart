class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardingModel> onboardingList = [
  OnboardingModel(
    image: 'assets/images/onboarding1.png',
    title: 'Create challenges that stick',
    description:
        'Pick a habit, set the rules, and invite your crew in under a minute.',
  ),
  OnboardingModel(
    image: 'assets/images/onboarding2.png',
    title: 'Compete with your crew',
    description:
        'Protect your streak while friends push you forward - friendly pressure, real progress.',
  ),
  OnboardingModel(
    image: 'assets/images/onboarding3.png',
    title: 'Earn points. Climb the ranks.',
    description:
        'Every check-in moves you up the leaderboard and unlocks achievements.',
  ),
];
