import 'package:flutter/material.dart';

import '../../../../../core/colors/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    // required this.width,
    required this.text,
    required this.obscure,
    required this.textEditingController,
    this.icon,
    this.onClickSuffixIcon,
    this.suffixColor,
  }) : super(key: key);

  // final double width;
  final String text;
  final IconData? icon;
  final bool obscure;
  final TextEditingController textEditingController;
  final Function()? onClickSuffixIcon;
  final Color? suffixColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: textEditingController,
        style: S.textStyles.textfieldText,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: S.textStyles.textfieldTitle,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: S.colors.white,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: onClickSuffixIcon,
            child: Icon(
              icon,
              size: 18,
              color: S.colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
