import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'navigation/route_paths.dart';

const bookShelf = 'book_shelf';

enum ProfileFeature {
  editProfile,
  changePassword,
  logOut,
}

extension ProfileFeatureExtension on ProfileFeature {

  String get name {
    switch (this) {
      case ProfileFeature.editProfile:
        return 'edit_profile'.tr();
      case ProfileFeature.changePassword:
        return 'change_password'.tr();
      case ProfileFeature.logOut:
        return 'log_out'.tr();
      default:
        return 'empty'.tr();
    }
  }

  void navigateEditProfile(BuildContext context, String displayName) {
    Navigator.pushNamed(context, RoutePaths.editProfile,
        arguments: displayName);
  }

  void navigateChangePassword(BuildContext context) {
    Navigator.pushNamed(context, RoutePaths.changePassword);
  }
  void navigateLogOut(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context, RoutePaths.logIn, (route) => false);
    FirebaseAuth.instance.signOut();
  }
}
