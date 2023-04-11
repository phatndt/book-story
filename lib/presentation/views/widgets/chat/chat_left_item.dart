import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/colors/colors.dart';

class ChattingLeftItem extends StatelessWidget {
  const ChattingLeftItem({
    Key? key,
    required this.message,
    required this.time,
  }) : super(key: key);
  final String message;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: <Widget>[
          // Container(
          //   width: 40,
          //   height: 40,
          //   child: CircleAvatar(
          //     backgroundImage: NetworkImage(image),
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.redAccent,
          //     shape: BoxShape.circle,
          //     border: Border.all(
          //       color: Colors.grey,
          //       width: 3,
          //     ),
          //     boxShadow: [
          //       BoxShadow(
          //           color: Colors.grey.withOpacity(.3),
          //           offset: const Offset(0, 5),
          //           blurRadius: 25)
          //     ],
          //   ),
          // ),
          SizedBox(
            width: S.size.length_10Vertical,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text(
              //   name,
              //   style: Theme.of(context).textTheme.caption,
              // ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .6),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: S.colors.accent_5,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300.w),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Text(
            time,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
