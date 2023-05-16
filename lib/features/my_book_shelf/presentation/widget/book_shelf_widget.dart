import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/colors/colors.dart';

class BookShelfWidget extends StatelessWidget {
  const BookShelfWidget({
    Key? key,
    required this.name,
    required this.numberOfBooks,
    required this.color,
  }) : super(key: key);
  final String name;
  final String numberOfBooks;
  final String color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: Color(int.parse("0x$color")),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: SizedBox(
        height: 104.h,
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                name,
                style: S.textStyles.heading2.copyWith(
                    fontWeight: FontWeight.w500, color: S.colors.white),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                "$numberOfBooks books",
                style: S.textStyles.heading3.copyWith(
                    fontWeight: FontWeight.w500, color: S.colors.white),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/feature/shelf/book_shelf_background.png',
                scale: 0.75,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
