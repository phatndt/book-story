import 'package:flutter/material.dart';
import '../../../../../core/colors/colors.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    Key? key,
    required this.width,
    required this.text,
    required this.onPress,
  }) : super(key: key);

  final double width;
  final String text;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text,
        style: S.textStyles.buttonText,
      ),
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        //padding: const EdgeInsets.all(0.8),
        minimumSize: Size(width, 60),
        // side: BorderSide(
        //   style: BorderStyle.solid,
        //   color: S.colors.white,
        //   width: 0.6,
        // ),
        textStyle: S.textStyles.smallTitle,
        primary: S.colors.background,
        onPrimary: S.colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            style: BorderStyle.solid,
            color: S.colors.white,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        elevation: 1.2,
      ),
    );
  }
}
