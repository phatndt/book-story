import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/colors/colors.dart';
import '../../../../domain/entities/combination_post.dart';

class PostItemWidget extends StatelessWidget {
  const PostItemWidget({
    Key? key,
    required this.combinationPost,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  final CombinationPost combinationPost;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(S.size.length_10),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: S.size.length_10Vertical,
            horizontal: S.size.length_10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostTitleWidget(
                imagePath: combinationPost.user.imageUrl,
                username: combinationPost.user.username,
                createDate: DateFormat('dd/MM/yyyy, hh:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(combinationPost.createDate))),
                onPressed: () {},
              ),
              SizedBox(
                height: S.size.length_20Vertical,
              ),
              Text(
                combinationPost.content,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 3,
              ),
              SizedBox(
                height: S.size.length_20Vertical,
              ),
              Container(
                height: 320.h,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(S.size.length_10),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(combinationPost.imageUrl),
                  ),
                ),
              ),
              const PostSpacing(),
            ],
          ),
        ),
      ),
    );
  }
}

class PostSpacing extends StatelessWidget {
  const PostSpacing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: S.size.length_4Vertical,
        ),
        const Divider(
          thickness: 1,
        ),
        SizedBox(
          height: S.size.length_4Vertical,
        ),
      ],
    );
  }
}

class PostTitleWidget extends StatelessWidget {
  const PostTitleWidget({
    Key? key,
    required this.imagePath,
    required this.username,
    required this.createDate,
    required this.onPressed,
  }) : super(key: key);
  final String imagePath;
  final VoidCallback onPressed;
  final String username;
  final String createDate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 32.w,
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
                Text(
                  username,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    color: S.colors.orange,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: S.size.length_8,
                ),
                Text(
                  createDate,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    color: S.colors.gray_3,
                    fontSize: 16,
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
    );
  }
}
