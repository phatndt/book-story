import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../colors/colors.dart';

class FooterScreen extends StatelessWidget {
  const FooterScreen({
    Key? key,
    required this.buttonContent,
    required this.onPressed,
  }) : super(key: key);

  final String buttonContent;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: S.size.length_16,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Ink(
          decoration: const ShapeDecoration(
            color: Colors.white,
            shape: CircleBorder(),
          ),
          width: ScreenUtil().scaleText * 48,
          height: ScreenUtil().scaleText * 48,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              FontAwesomeIcons.arrowLeft,
              color: S.colors.orange,
            ),
            color: S.colors.orange,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            // child: Padding(
            //   padding: EdgeInsets.all(ScreenUtil().scaleText * 12),
            //   child: Icon(
            //     FontAwesomeIcons.arrowLeft,
            //     color: S.colors.orange,
            //   ),
            // ),
            // style: ElevatedButton.styleFrom(
            //   shape: const CircleBorder(),
            //   elevation: 0.5,
            //   primary: Colors.white,
            // ),
          ),
        ),
      ),
    );
  }
}
