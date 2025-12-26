import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/core/constants/app_colors.dart';
import 'package:recipe_app/core/constants/text_form_field.dart';
import 'package:recipe_app/core/constants/text_styles.dart';
import 'package:recipe_app/providers/auth_controller.dart';
import 'package:recipe_app/views/auth/register_screen.dart';
import 'package:recipe_app/views/home/nav_wrapper.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Controllers to capture the text typed by the user
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isHidden = false;

  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _mailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 80.0,
            ),
            child: Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Icon(
                    Icons.restaurant_menu,
                    size: 60,
                    color: AppColors.primartTeal,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome Back!!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primartTeal,
                    ),
                  ),
                  Text(
                    "Sign in to continue your culinary journey",
                    style: TextStyles.h3(AppColors.textLight),
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  // buildLabel("Email Address"),
                  CustomTextFormField(
                    controller: _mailController,
                    hintText: "Enter Your Email",
                    labelText: 'Email',
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    prefixIconEnable: true,
                    prefixIcon: Icon(Icons.mail_outlined),
                  ),
                  const SizedBox(height: 5),

                  // Password Field
                  // buildLabel("Password"),
                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: "Enter Your Password",
                    labelText: 'Password',
                    validation: (value) {
                      if (value == null || value.length < 4) {
                        return 'Minimum 4 characters';
                      }
                      return null;
                    },
                    prefixIconEnable: true,
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIconEnable: true,
                    isPassword: !isHidden,
                    suffixIcon: isHidden
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onSuffixIcon: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                  ),

                  // Forgot Password Link
                  /*Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to Forgot Password Screen later
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyles.h3(AppColors.primartTeal),
                      ),
                    ),
                  ),*/
                  const SizedBox(height: 5),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_loginFormKey.currentState!.validate()) {
                          try {
                            await ref
                                .read(authControllerProvider.notifier)
                                .login(
                                  email: _mailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );

                            // Navigate to Home after login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MainNavigationWrapper(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primartTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyles.h2(AppColors.cardWhite),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyles.largeSubtitle(AppColors.textDark),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyles.h3(AppColors.primartTeal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
