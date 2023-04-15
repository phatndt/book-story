import 'package:flutter/material.dart';

class SuccessSnackBar extends SnackBar {
  SuccessSnackBar({super.key, required String message})
      : super(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF3BBD9F),
        );
}

class WarningSnackBar extends SnackBar {
  WarningSnackBar({super.key, required String message})
      : super(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFF7D150),
        );
}

class ErrorSnackBar extends SnackBar {
  ErrorSnackBar({super.key, required String message})
      : super(
          content: Text(message.substring(11)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFFF5158),
        );
}

