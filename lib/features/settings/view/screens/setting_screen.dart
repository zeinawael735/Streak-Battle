import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/utils/app_toast.dart';
import '../../../auth/login/view_model/login_state.dart';
import 'package:toastification/toastification.dart';
import '../../../auth/login/view/screens/login_screen.dart';
import '../../../auth/login/view_model/login_cubit.dart';
import '../widgets/appearance_card.dart';
import '../widgets/red_button.dart';
import '../widgets/profile_card.dart';
import '../widgets/setting_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationEnabled = true;
  bool _isLoadingNotification = true;

  @override
  void initState() {
    super.initState();
    _fetchNotificationState();
  }

  Future<void> _fetchNotificationState() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          _isNotificationEnabled = doc.data()?['isNotificationEnabled'] ?? true;
          _isLoadingNotification = false;
        });
      }
    }
  }

  Future<void> _toggleNotification(bool value) async {
    setState(() {
      _isNotificationEnabled = value;
    });

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'isNotificationEnabled': value,
        });
      } catch (e) {
        if (mounted) {
          setState(() {
            _isNotificationEnabled = !value;
          });
          AppToast.showToast(
            context: context,
            title: "Update Failed",
            description: "Could not update notification settings.",
            type: ToastificationType.error,
          );
        }
      }
    }
  }

  void _showFeedbackDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Help & Feedback',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
            fontSize: 20,
          ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 0,
            ),
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
    return BlocProvider(
      create: (context) => LoginCubit()..getUserData(),
      child: Builder(
        builder: (newContext) {
          final loginCubit = newContext.read<LoginCubit>();
          return BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                AppToast.showToast(
                  context: context,
                  title: "You have been logged out...",
                  description: "Login Again To Continue Challenging",
                  type: ToastificationType.info,
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
              if (state is LogoutError) {
                AppToast.showToast(
                  context: context,
                  title: "Logout Failed",
                  description: state.message,
                  type: ToastificationType.error,
                );
              }
              if (state is DeleteAccountError) {
                AppToast.showToast(
                  context: context,
                  title: "Account Deletion Failed",
                  description: state.message,
                  type: ToastificationType.error,
                );

                if (state is RequiresReAuthentication) {
                  AppToast.showToast(
                    context: context,
                    title: "Security Check",
                    description:
                        "Please log in again before deleting your account for security reasons.",
                    type: ToastificationType.error,
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              }
              if (state is DeleteAccountSuccess) {
                AppToast.showToast(
                  context: context,
                  title: "Account Deleted",
                  description: "Your account has been successfully deleted.",
                  type: ToastificationType.success,
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).textTheme.headlineSmall?.color,
                      size: 23,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileCard(
                        name: loginCubit.userName.isEmpty
                            ? '...'
                            : loginCubit.userName,
                        email: loginCubit.currentUserEmail,
                        onTap: () {},
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('PREFERENCES', context),
                      const SizedBox(height: 8),

                      Material(
                        color: Theme.of(context).colorScheme.onTertiaryFixed,
                        borderRadius: BorderRadius.circular(12),
                        clipBehavior: Clip.antiAlias,
                        child: SwitchListTile(
                          value: _isNotificationEnabled,
                          onChanged: _isLoadingNotification
                              ? null
                              : _toggleNotification,
                          activeColor: Theme.of(context).primaryColor,
                          activeThumbColor: Colors.white,
                          activeTrackColor: Theme.of(context).primaryColor,
                          inactiveTrackColor: Colors.grey,

                          title: Text(
                            'Notifications',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            _isNotificationEnabled
                                ? 'Daily reminders enabled'
                                : 'Daily reminders disabled',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                          secondary: Icon(
                            Icons.notifications_none_rounded,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      const AppearanceCard(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('ACCOUNT & SUPPORT', context),
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
                      RedButton(
                        onTap: () {
                          loginCubit.logout();
                        },
                        text: 'Log Out',
                        icon: Icons.logout,
                        borderColor:Color(0xFF7911FF),
                        iconColor: Color(0xFF7911FF),
                      ),
                      const SizedBox(height: 16),
                      RedButton(
                        onTap: () {
                          loginCubit.deleteAccount();
                        },
                        text: 'Delete Account',
                        icon: Icons.delete,
                        borderColor: Colors.redAccent.shade700,
                        iconColor: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }
}
