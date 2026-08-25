class OnboardingModel {
  final String title;
  final String description;

  OnboardingModel({
    required this.title,
    required this.description,
  });
}

List<OnboardingModel> onboardingList = [
  OnboardingModel(
    title: 'Create challenges that stick',
    description:
    'Pick a habit, set the rules, and invite your crew in under a minute.',
  ),
  OnboardingModel(
    title: 'Compete with your crew',
    description:
    'Protect your streak while friends push you forward - friendly pressure, real progress.',
  ),
  OnboardingModel(
    title: 'Earn points. Climb the ranks.',
    description:
    'Every check-in moves you up the leaderboard and unlocks achievements.',
  ),
];