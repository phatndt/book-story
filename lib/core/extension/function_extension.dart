import 'package:book_exchange/core/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../colors/colors.dart';

extension Ext on Object? {
  void ifNotEmpty(
    Function() action,
    Function() empty,
    Function() notVerify,
  ) {
    if (this == "notVerify") {
      notVerify();
    } else if (this != "") {
      action();
    } else {
      empty();
    }
  }
}

void catchOnError(context, dynamic onError) {
  if (onError.toString() == "Unauthorized") {
    Dialogs.materialDialog(
      msg: 'Your session are expired. \nPlease login again!',
      msgAlign: TextAlign.center,
      title: "Unauthorized",
      color: Colors.white,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutePaths.logIn, (route) => false);
          },
          text: 'Log out',
          iconData: Icons.logout,
          color: S.colors.orange,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  } else {
    showTopSnackBar(
      context,
      CustomSnackBar.info(
        message: "Error: $onError",
      ),
      displayDuration: const Duration(seconds: 2),
    );
  }
}
