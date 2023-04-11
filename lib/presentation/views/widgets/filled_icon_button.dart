import 'package:flutter/material.dart';
import '../../../../../core/colors/colors.dart';

class CustomFilledIconButton extends StatelessWidget {
  const CustomFilledIconButton({
    Key? key,
    this.width = double.infinity,
    this.height,
    required this.iconData,
    required this.onPress,
    this.size,
    this.color,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double? size;
  final Color? color;
  final IconData iconData;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        child: Center(
          child: Icon(
            iconData,
            size: size,
            color: color,
          ),
        ),
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
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
      ),
    );
  }
}
