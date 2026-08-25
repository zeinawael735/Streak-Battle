import 'package:flutter/material.dart';

class AppearanceCard extends StatefulWidget {
  const AppearanceCard({super.key});

  @override
  State<AppearanceCard> createState() => _AppearanceCardState();
}

class _AppearanceCardState extends State<AppearanceCard> {
  String selectedTheme = 'Dark';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiaryFixed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Theme.of(context).textTheme.bodySmall?.color, size: 20),
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
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [

              _buildOption('Light'),
              const SizedBox(width: 8),
              _buildOption('Dark'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String mode) {
    final isSelected = selectedTheme == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTheme = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,//const Color(0xFF222027),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            mode,
            style: TextStyle(
              color: isSelected ? Colors.white : Theme.of(context).textTheme.bodySmall?.color,//Colors.grey.shade400,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}