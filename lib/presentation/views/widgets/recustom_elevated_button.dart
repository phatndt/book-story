import 'package:flutter/material.dart';
import '../../../../../core/colors/colors.dart';

class ReCustomElevatedButton extends StatelessWidget {
  const ReCustomElevatedButton({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    required this.onPress,
  }) : super(key: key);

  final double width;
  final double height;
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
        fixedSize: Size(width, height),
        // side: BorderSide(
        //   color: S.colors.white,
        //   width: 0.6,
        // ),
        primary: S.colors.orange,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        elevation: 1.2,
      ),
    );
  }
}
