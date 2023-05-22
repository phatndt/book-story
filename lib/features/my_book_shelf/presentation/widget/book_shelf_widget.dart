import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/colors/colors.dart';
import '../../../../core/navigation/route_paths.dart';

class BookShelfWidget extends StatelessWidget {
  const BookShelfWidget({
    Key? key,
    required this.name,
    required this.numberOfBooks,
    required this.color,
    required this.onTap,
    required this.index,
  }) : super(key: key);
  final String name;
  final String numberOfBooks;
  final String color;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Card(
        elevation: 0.5,
        color: Color(int.parse("0x$color")),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: SizedBox(
          height: 104.h,
          child: Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: S.textStyles.heading2.copyWith(
                      fontWeight: FontWeight.w500, color: S.colors.white),
                ),
                Text(
                  "$numberOfBooks books",
                  style: S.textStyles.heading3.copyWith(
                      fontWeight: FontWeight.w500, color: S.colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
