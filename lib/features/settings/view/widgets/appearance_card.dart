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
        color: const Color(0xFF16151A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.purple.shade300, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Appearance',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Choose how Streak Battle looks',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
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
            color:
                isSelected ? Colors.purple.shade800 : const Color(0xFF222027),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            mode,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade400,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
