import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    this.width = double.infinity,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.borderRadius = 8,
    this.elevation,
  }) : super(key: key);

  final double width;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double borderRadius;
  final double? elevation;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double?>(elevation),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          backgroundColor:  MaterialStateProperty.all<Color>(backgroundColor ?? S.colors.primary_3),
          padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w)),
        ),
        child: child,
      ),
    );
  }
}

