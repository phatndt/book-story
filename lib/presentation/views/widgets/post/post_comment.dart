import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/colors/colors.dart';

// class PostComment extends StatelessWidget {
//   const PostComment({
//     Key? key,
//     required this.icon,
//     required this.count,
//     required this.onPressed,
//   }) : super(key: key);

//   final IconData icon;
//   final String count;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Row(
//         children: [
//           Icon(icon),
//           SizedBox(
//             width: S.size.length_10,
//           ),
//           Text(count),
//         ],
//       ),
//     );
//   }
// }

class PostComment extends StatelessWidget {
  const PostComment({
    Key? key,
    required this.imagePath,
    required this.username,
    required this.content,
    required this.createDate,
  }) : super(key: key);
  final String imagePath;
  final String username;
  final String content;
  final String createDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 8.h,
      ),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20.w,
              backgroundImage: imagePath.isNotEmpty
                  ? NetworkImage(imagePath)
                  : const NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSegCgK5aWTTuv_K5TPd10DcJxphcBTBct6R170EamgcCOcYs7LGKVy7ybRc-MCwOcHljg&usqp=CAU"),
            ),
            SizedBox(
              width: S.size.length_10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: S.colors.gray_4,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: S.colors.orange,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          content,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: S.colors.gray_1,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    createDate,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: S.colors.gray_2,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // GestureDetector(
            //   child: const Icon(FontAwesomeIcons.ellipsisVertical),
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
