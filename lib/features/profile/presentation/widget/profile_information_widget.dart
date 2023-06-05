import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/colors/colors.dart';

class ProfileInformationWidget extends StatelessWidget {
  const ProfileInformationWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: S.textStyles.heading3.copyWith(
            fontWeight: FontWeight.bold,
            color: S.colors.primary_3,
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          title,
          style: S.textStyles.paragraph.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}

class ProfileInformationDivider extends StatelessWidget {
  const ProfileInformationDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      child: VerticalDivider(
        color: Colors.grey,
        width: 12.w,
        thickness: 2,
      ),
    );
  }
}
