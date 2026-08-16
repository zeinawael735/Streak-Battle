import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';
import 'package:streak_battle/core/routes/app_routes.dart';

import '../../../../../core/common/custom_text_field.dart';
import '../../view_model/sign_up_cubit.dart';
import '../../view_model/sign_up_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool termsAccepted = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submitForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      if (!termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the Terms & Privacy Policy'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      context.read<SignUpCubit>().signUp(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: Scaffold(
        backgroundColor: AppColorStyle.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Create Account",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColorStyle.primaryText,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColorStyle.primaryText,
              size: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.appSection,
                    (route) => false,
              );
            } else if (state is SignUpError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: isKeyboardOpen
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 24,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  "Join the arena",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Build better habits with people you trust.",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColorStyle.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 30),

                                CustomTextFormField(
                                  controller: nameController,
                                  hintText: "Alex Morgan",
                                  borderRadius: BorderRadius.circular(12),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: AppColorStyle.primaryText,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Name is required";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                CustomTextFormField(
                                  controller: emailController,
                                  hintText: "alex@email.com",
                                  keyboardType: TextInputType.emailAddress,
                                  borderRadius: BorderRadius.circular(12),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: AppColorStyle.primaryText,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Email is required";
                                    }
                                    final emailRegex =
                                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                    if (!emailRegex.hasMatch(value.trim())) {
                                      return "Enter a valid email address";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                CustomTextFormField(
                                  controller: passwordController,
                                  hintText: "Create a password",
                                  isPassword: true,
                                  borderRadius: BorderRadius.circular(12),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: AppColorStyle.primaryText,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password is required";
                                    }
                                    if (value.length < 8) {
                                      return "Password must be at least 8 characters";
                                    }
                                    return null;
                                  },
                                ),
                                 SizedBox(height: 16),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: termsAccepted,
                                        checkColor: AppColorStyle.primaryText,
                                        activeColor: AppColorStyle.primaryViolet,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            termsAccepted = val ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                     SizedBox(width: 10),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          text: "I agree to the ",
                                          style: TextStyle(
                                            color: AppColorStyle.primaryText,
                                            fontSize: 13,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Terms of Service ",
                                              style: TextStyle(
                                                color: AppColorStyle.primaryViolet,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                             TextSpan(text: "and "),
                                            TextSpan(
                                              text: "Privacy Policy.",
                                              style: TextStyle(
                                                color: AppColorStyle.primaryViolet,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                             SizedBox(height: 20),

                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: state is SignUpLoading
                                        ? null
                                        : () => submitForm(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColorStyle.primaryViolet,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: state is SignUpLoading
                                        ?  SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                        :  Text(
                                      "Create Account",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                 SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Text(
                                        "Log in",
                                        style: TextStyle(
                                          color: AppColorStyle.primaryText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                 SizedBox(height: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}