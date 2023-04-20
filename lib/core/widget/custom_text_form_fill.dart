import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    required this.obscureText,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
    this.inputType,
    this.controller,
    this.focusNode,
    this.width = double.infinity,
    this.height,
    this.maxLines = 1,
    this.autofocus = false,
    this.onTap,
    this.readOnly = false,
    this.maxLength,
    this.textInputAction,
  }) : super(key: key);

  final FocusNode? focusNode;
  final String hintText;
  final Widget? prefixIconData;
  final Widget? suffixIconData;
  final bool obscureText;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final Function(String? value)? onFieldSubmitted;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final int? maxLines;
  final bool autofocus;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLength;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        onTap: onTap,
        readOnly: readOnly,
        autofocus: autofocus,
        maxLines: maxLines,
        focusNode: focusNode,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: inputType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        style: const TextStyle(
          fontFamily: 'Lato',
          //color: Color.fromARGB(255, 150, 27, 25),
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        maxLength: maxLength,
        decoration: InputDecoration(
          filled: true,
          fillColor: S.colors.primary_1,
          contentPadding:
          EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          counterText: "",
          isDense: true,
          hintStyle: const TextStyle(
            fontFamily: 'Lato',
            //color: Color.fromARGB(255, 150, 27, 25),
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(const Radius.circular(12).w),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: S.colors.primary_3, width: 2),
            borderRadius: BorderRadius.all(const Radius.circular(12).w),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: S.colors.red, width: 1),
            borderRadius: BorderRadius.all(const Radius.circular(12).w),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: S.colors.red, width: 2),
            borderRadius: BorderRadius.all(const Radius.circular(12).w),
          ),
          prefixIcon: prefixIconData,
          suffixIcon: suffixIconData,
        ),
      ),
    );
  }
}
