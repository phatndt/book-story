import 'package:flutter/material.dart';

import 'colors/colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.hintText,
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
  }) : super(key: key);

  final FocusNode? focusNode;
  final String? hintText;
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, S.size.length_10, 0, S.size.length_20),
      child: SizedBox(
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
          onChanged: onChanged,
          validator: validator,
          obscureText: obscureText,
          style: S.textStyles.textTextFieldStyle,
          maxLength: maxLength,
          decoration: InputDecoration(
            counterText: "",
            isDense: true,
            hintText: hintText,
            hintStyle: S.textStyles.hintText,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                color: S.colors.white,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                color: S.colors.white,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                color: S.colors.orange,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: S.colors.background_2,
            prefixIcon: prefixIconData,
            suffixIcon: suffixIconData,
          ),
        ),
      ),
    );
  }
}
