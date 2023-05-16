import 'package:flutter/material.dart';

import '../colors/colors.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    super.title,
    super.leading,
    super.actions,
  }) : super(
          backgroundColor: S.colors.white,
          elevation: 0.5,
        );
}
