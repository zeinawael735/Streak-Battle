import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onTap;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String getInitials(String name) {
      if (name.trim().isEmpty) return "";
      final parts = name.trim().split(' ');
      if (parts.length > 1 && parts[1].isNotEmpty) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
    }
    return Container(
      decoration: BoxDecoration(
        color:  Theme.of(context).colorScheme.onTertiaryFixed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            name.isNotEmpty ? getInitials(name) : '',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        subtitle: Text(
          email,
          style: TextStyle(color: Colors.grey[700],fontSize: 17),
        ),
      ),
    );
  }
}