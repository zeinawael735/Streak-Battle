import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
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
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Theme.of(context).textTheme.bodySmall?.color, size: 25),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style:  TextStyle(color: Colors.grey[700], fontWeight: FontWeight.normal, fontSize: 14),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      ),
    );
  }
}