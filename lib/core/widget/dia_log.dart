import 'package:flutter/material.dart';

class BasicAlertDialog extends StatelessWidget {
  const BasicAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.negativeButton,
    required this.positiveButton,
  }) : super(key: key);
  final String title;
  final String content;
  final VoidCallback negativeButton;
  final VoidCallback positiveButton;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: negativeButton,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: positiveButton,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
