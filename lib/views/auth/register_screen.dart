import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/core/constants/app_colors.dart';
import 'package:recipe_app/core/constants/text_form_field.dart';
import 'package:recipe_app/providers/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPwdHidden = true;
  bool _isCnfPwdHidden = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_registerFormKey.currentState!.validate()) {
      print("Form is valid! Ready for Firebase.");

      try {
        await ref
            .read(authControllerProvider.notifier)
            .register(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              fullName: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
            );

        // After successful register → go back to login
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.primartTeal),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _registerFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primartTeal,
                ),
              ),
              const Text(
                "Fill the details to start your journey",
                style: TextStyle(fontSize: 16, color: AppColors.textLight),
              ),
              const SizedBox(height: 30),

              // Full Name Field
              CustomTextFormField(
                controller: _nameController,
                hintText: "Enter Full Name",
                labelText: "Full Name",
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please entry your name";
                  }
                  return null;
                },
                prefixIconEnable: true,
                prefixIcon: Icon(Icons.person_outline),
              ),

              // Email Field
              CustomTextFormField(
                controller: _emailController,
                hintText: "Enter Email Address",
                labelText: "Email",
                keyboardType: TextInputType.emailAddress,
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
                prefixIconEnable: true,
                prefixIcon: Icon(Icons.email_outlined),
              ),

              // Phone Field
              CustomTextFormField(
                controller: _phoneController,
                hintText: "Enter Phone number",
                labelText: "Phone Number",
                maxLength: 10,
                keyboardType: TextInputType.phone,
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is required";
                  }
                  if (value.length < 10) {
                    return "Please enter a valid Phone Number";
                  }
                  return null;
                },
                prefixIconEnable: true,
                prefixIcon: Icon(Icons.phone_in_talk_outlined),
              ),

              // Password Field
              CustomTextFormField(
                controller: _passwordController,
                hintText: "Enter Password",
                labelText: "Password",
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password Required";
                  }
                  if (value.length < 4) {
                    return "Password must be at 4 characters";
                  }
                  return null;
                },
                prefixIconEnable: true,
                prefixIcon: Icon(Icons.lock_outline),
                suffixIconEnable: true,
                isPassword: _isPwdHidden,
                suffixIcon: _isPwdHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onSuffixIcon: () {
                  setState(() {
                    _isPwdHidden = !_isPwdHidden;
                  });
                },
              ),

              // Confirm Password Field
              CustomTextFormField(
                controller: _confirmPasswordController,
                hintText: "Re-Entry Password",
                labelText: "Confirm Password",
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }
                  if (value != _passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                prefixIconEnable: true,
                prefixIcon: Icon(Icons.lock_reset),
                suffixIconEnable: true,
                isPassword: _isCnfPwdHidden,
                suffixIcon: _isCnfPwdHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
                onSuffixIcon: () {
                  setState(() {
                    _isCnfPwdHidden = !_isCnfPwdHidden;
                  });
                },
              ),

              const SizedBox(height: 40),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primartTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
