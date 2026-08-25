import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';
import 'package:streak_battle/core/routes/app_routes.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/common/custom_text_field.dart';
import '../../../../../core/utils/app_dialog.dart';
import '../../../../../core/utils/app_toast.dart';
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
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      if (!termsAccepted) {
        AppToast.showToast(
          context: context,
          title: "Warning",
          description: "Please accept the Terms & Privacy Policy",
          type: ToastificationType.warning,
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            "Create Account",
            style: Theme.of(context).textTheme.headlineMedium
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).textTheme.headlineSmall?.color,
              size: 23,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpLoading) {
              AppDialogs.showLoadingDialog(context);
              return;
            }

            Navigator.of(context, rootNavigator: true).pop();

            if (state is SignUpError) {
              AppToast.showToast(
                context: context,
                title: "Error",
                description: state.message,
                type: ToastificationType.error,
              );
            } else if (state is SignUpSuccess) {
              AppToast.showToast(
                context: context,
                title: "Success",
                description: "Account created successfully!",
                type: ToastificationType.success,
              );

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.appSection,
                    (route) => false,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     SizedBox(height: 25),
                     Text(
                      "Join the arena",
                      style: Theme.of(context).textTheme.headlineLarge
                    ),
                     SizedBox(height: 8),
                    Text(
                      "Build better habits with people you trust.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 15,fontWeight: FontWeight.w500)
                    ),
                     SizedBox(height: 30),

                    CustomTextFormField(
                      controller: nameController,
                      hintText: "Alex Morgan",
                      borderRadius: BorderRadius.circular(12),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
                     SizedBox(height: 16),

                    CustomTextFormField(
                      controller: emailController,
                      hintText: "alex@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                      borderRadius: BorderRadius.circular(12),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Theme.of(context).textTheme.bodySmall?.color,
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
                     SizedBox(height: 16),

                    CustomTextFormField(
                      controller: passwordController,
                      hintText: "Create a password",
                      isPassword: true,
                      borderRadius: BorderRadius.circular(12),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Theme.of(context).textTheme.bodySmall?.color,
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
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12,fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                  text: "Terms of Service ",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                 TextSpan(text: "and "),
                                TextSpan(
                                  text: "Privacy Policy.",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => submitForm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          elevation: 0,
                        ),
                        child:  Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                     SizedBox(height: 60),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
            ? Align(
          alignment: Alignment.bottomCenter,
          child: Text.rich(
            TextSpan(
              text: "Already have an account? ",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14,fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: "Log in",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pop(context);
                    },
                ),
              ],
            ),
          ),
        )
            : null,
      ),
    );
  }
}