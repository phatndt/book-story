import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/colors/colors.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.action1Title,
    required this.action2Title,
    required this.action,
  }) : super(key: key);

  final String title;
  final String content;
  final String action1Title;
  final String action2Title;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          S.size.length_8,
        ),
      ),
      title: Text(title),
      titleTextStyle: S.textStyles.alertdialog.title,
      content: Text(content),
      contentTextStyle: S.textStyles.alertdialog.content,
      actions: [
        CupertinoDialogAction(
          child: Text(
            action1Title,
          ),
          onPressed: action,
          isDefaultAction: true,
        ),
        CupertinoDialogAction(
          child: Text(
            action2Title,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          isDestructiveAction: true,
        ),
      ],
    );
  }
}
