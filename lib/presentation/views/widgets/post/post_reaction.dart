import 'package:flutter/material.dart';

import '../../../../core/colors/colors.dart';

class PostReaction extends StatelessWidget {
  const PostReaction({
    Key? key,
    required this.icon,
    required this.count,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final String count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: S.size.length_10,
          ),
          Text(count),
        ],
      ),
    );
  }
}
