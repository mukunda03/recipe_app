import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?) validation;
  final String labelText;
  final String hintText;
  final bool isPassword;
  final bool prefixIconEnable;
  final int? maxLength;
  final Icon? prefixIcon;
  final bool suffixIconEnable;
  final Icon? suffixIcon;
  final VoidCallback? onSuffixIcon;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.keyboardType,
    this.isPassword = false,
    this.prefixIconEnable = false,
    this.prefixIcon,
    this.suffixIconEnable = false,
    this.suffixIcon,
    this.onSuffixIcon,
    this.maxLength,
    required this.validation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        obscureText: isPassword,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        validator: validation,
        maxLength: maxLength,

        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          counterText: '',
          prefixIcon: prefixIconEnable ? prefixIcon : null,
          suffixIcon: suffixIconEnable
              ? IconButton(onPressed: onSuffixIcon, icon: suffixIcon!)
              : null,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 1.2),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primartTeal, width: 2),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1.5),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),

          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

Widget buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    ),
  );
}
