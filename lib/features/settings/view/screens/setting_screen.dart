import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/appearance_card.dart';
import '../widgets/log_out.dart';
import '../widgets/profile_card.dart';
import '../widgets/setting_tile.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showFeedbackDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16151A),
        title: const Text('Help & Feedback', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Write your feedback here...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('feedbacks').add({
                  'text': controller.text,
                  'userId': FirebaseAuth.instance.currentUser?.uid,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                if (mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            ProfileCard(
              name: 'Alex Morgan',
              email: 'alex@email.com',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('PREFERENCES',context),
            const SizedBox(height: 8),
            SettingsTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Daily reminder on',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            const AppearanceCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('ACCOUNT & SUPPORT',context),
            const SizedBox(height: 8),
            SettingsTile(
              icon: Icons.info_outline,
              title: 'Help & feedback',
              subtitle: 'FAQ, contact, report a bug',
              onTap: () {
                _showFeedbackDialog();
              },
            ),
            const SizedBox(height: 24),
            LogoutButton(onTap: () {}),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}