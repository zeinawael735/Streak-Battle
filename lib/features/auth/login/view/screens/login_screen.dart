import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:streak_battle/core/constants/app_assets.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';
import 'package:streak_battle/core/routes/app_routes.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/common/custom_text_field.dart';
import '../../../../../core/utils/app_dialog.dart';
import '../../../../../core/utils/app_toast.dart';
import '../../view_model/login_cubit.dart';
import '../../view_model/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext innerContext) {
    FocusScope.of(innerContext).unfocus();
    if (_formKey.currentState!.validate()) {
      innerContext.read<LoginCubit>().login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: AppColorStyle.scaffoldBackgroundColor,
        body: Builder(
          builder: (innerContext) {
            return BlocListener<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginLoading) {
                  AppDialogs.showLoadingDialog(context);
                  return;
                }

                Navigator.of(context, rootNavigator: true).pop();

                if (state is LoginError) {
                  AppToast.showToast(
                    context: context,
                    title: "Login Failed",
                    description: state.message,
                    type: ToastificationType.error,
                  );
                } else if (state is LoginSuccess) {
                  AppToast.showToast(
                    context: context,
                    title: "Welcome",
                    description: "Successfully logged in.",
                    type: ToastificationType.success,
                  );

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.appSection,
                        (route) => false,
                  );
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColorStyle.primaryViolet,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:  Icon(
                          Icons.bolt,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                       SizedBox(height: 20),
                       Text(
                        "Welcome back",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                       SizedBox(height: 8),
                      Text(
                        "Log in and keep your streak alive.",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColorStyle.primaryText,
                        ),
                      ),
                       SizedBox(height: 28),

                       Text(
                        "Email",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                       SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _emailController,
                        hintText: "alex@gmail.com",
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
                       SizedBox(height: 16),

                       Text(
                        "Password",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                       SizedBox(height: 8),
                      CustomTextFormField(
                        controller: _passwordController,
                        hintText: "••••••••",
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
                          return null;
                        },
                      ),
                       SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.forgotPassword);
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: AppColorStyle.primaryViolet,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                       SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => _submitForm(innerContext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColorStyle.primaryViolet,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child:  Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                       SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[800])),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "- or continue with -",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[800])),
                        ],
                      ),
                       SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            innerContext.read<LoginCubit>().loginWithGoogle();
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor:  Color(0xFF201F1F),
                            side:  BorderSide(color: Colors.black12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.googleIconSvg,
                                width: 27,
                                height: 27,
                              ),
                               SizedBox(width: 8),
                               Text(
                                "Continue with Google",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                       SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding:  EdgeInsets.only(bottom: 24, top: 8),
          child: Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text: "New to Streak Battle? ",
              style: TextStyle(color: AppColorStyle.primaryText, fontSize: 14),
              children: [
                TextSpan(
                  text: "Create an account",
                  style: TextStyle(
                    color: AppColorStyle.primaryViolet,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(context, AppRoutes.signUp);
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}