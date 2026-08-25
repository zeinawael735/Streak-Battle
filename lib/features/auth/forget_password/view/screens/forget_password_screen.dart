import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/common/common.dart';
import 'package:streak_battle/core/utils/responsive_helper.dart';
import '../../../../../core/common/custom_text_field.dart';
import '../../view_model/forget_password_cubit.dart';
import '../../view_model/forget_password_state.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgetPasswordCubit(),
      child: const _ForgetPasswordView(),
    );
  }
}

class _ForgetPasswordView extends StatefulWidget {
  const _ForgetPasswordView();

  @override
  State<_ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<_ForgetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = textColor.withOpacity(0.6);
    final surfaceColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF2F2F2);
    final r = ResponsiveHelper(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).textTheme.headlineSmall?.color,
            size: 23,
          ),
        ),
        title: Text('Forgot Password', style: theme.textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: theme.colorScheme.error),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ForgetPasswordLoading;
          final isSuccess = state is ForgetPasswordSuccess;

          return SingleChildScrollView(
            padding: EdgeInsets.only(left: 25,right: 25,top: 35),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.h(20)),
                  Center(
                    child: Container(
                      width: r.w(90),
                      height: r.w(90),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(r.w(20)),
                      ),
                      child: Icon(Icons.lock_reset,
                          color: Colors.white, size: r.w(40)),
                    ),
                  ),
                  SizedBox(height: r.h(24)),
                  Text('Reset your password',
                      style: TextStyle(
                          color: textColor,
                          fontSize: r.sp(22),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: r.h(8)),
                  Text(
                    'Enter the email linked to your account. We will send a secure reset link.',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 13,fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: r.h(24)),
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: 'alex@email.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: r.h(24)),
                  CustomButton(
                    label: isSuccess && state.remainingSeconds > 0
                        ? 'Resend in ${state.remainingSeconds}s'
                        : 'Send reset link',
                    isLoading: isLoading,
                    onPressed: (isSuccess && state.remainingSeconds > 0)
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<ForgetPasswordCubit>()
                            .sendResetLink(_emailController.text);
                      }
                    },
                  ),
                  SizedBox(height: r.h(16)),
                  if (isSuccess)
                    Container(
                      padding: EdgeInsets.all(r.w(12)),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(r.w(12)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: theme.colorScheme.primary, size: r.w(18)),
                          SizedBox(width: r.w(8)),
                          Expanded(
                            child: Text(
                              'Link expires in 30 minutes. Check your spam folder too.',
                              style: TextStyle(
                                  color: secondaryTextColor, fontSize: r.sp(12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}