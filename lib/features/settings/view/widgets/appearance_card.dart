import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_cubit.dart';

class AppearanceCard extends StatelessWidget {
  const AppearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, currentThemeMode) {
        final String selectedTheme =
        currentThemeMode == ThemeMode.light ? 'Light' : 'Dark';

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onTertiaryFixed,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Choose how Streak Battle looks',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildOption(context, 'Light', selectedTheme),
                  const SizedBox(width: 8),
                  _buildOption(context, 'Dark', selectedTheme),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(BuildContext context, String mode, String selectedTheme) {
    final isSelected = selectedTheme == mode;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<ThemeCubit>().toggleTheme(mode);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            mode,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}