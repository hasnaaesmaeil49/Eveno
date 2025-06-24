import 'package:evently_app/utls/app_colo.dart';
import 'package:evently_app/utls/app_style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  Color? borderColor;
  String hintText;
  String? labelText;
  TextStyle? hintStyle;
  TextStyle? labelStyle;
  TextStyle? style;
  Widget? prefixIcon;
  Widget? suffixIcon;
  bool? obscureText;
  int? maxLines;
  TextInputType? keyboardType; // ✅ الجديد
  String? Function(String?)? validator;
  TextEditingController? controller;

  CustomTextField({
    this.borderColor,
    required this.hintText,
    this.labelText,
    this.hintStyle,
    this.prefixIcon,
    this.controller,
    this.suffixIcon,
    this.labelStyle,
    this.style,
    this.obscureText,
    this.maxLines = 1,
    this.validator,
    this.keyboardType, // ✅ أضفناه هنا كمان
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: style,
      maxLines: maxLines,
      keyboardType: keyboardType, // ✅ استخدمناه هنا
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: borderColor ?? AppColor.greyColor,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: borderColor ?? AppColor.greyColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColor.redColor,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColor.redColor,
            width: 2,
          ),
        ),
        hintText: hintText,
        labelText: labelText,
        hintStyle: hintStyle ?? AppStyle.grey16Medium,
        labelStyle: labelStyle ?? AppStyle.grey16Medium,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText ?? false,
      obscuringCharacter: "*",
      cursorColor: AppColor.blackColor,
    );
  }
}