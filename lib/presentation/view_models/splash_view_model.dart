import 'dart:developer';

import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/domain/use_cases/main/get_is_first_time_app.dart';
import 'package:book_exchange/domain/use_cases/main/save_is_first_time_app.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashProvider {
  SplashProvider(this.ref, this._getIsFirstTimeAppUseCase,
      this._saveIsFirstTimeAppUseCase);

  final Ref ref;
  final GetIsFirstTimeAppUseCase _getIsFirstTimeAppUseCase;
  final SaveIsFirstTimeAppUseCase _saveIsFirstTimeAppUseCase;

  init(context) async {
    bool? isFirstTime = await _getIsFirstTimeAppUseCase.getIsFirstTimeApp();
    switch (isFirstTime) {
      case null:
        {
          log("0");
          _saveIsFirstTimeAppUseCase.saveIsFirstTime();
          Navigator.pushNamedAndRemoveUntil(
              context, RoutePaths.welcome, (route) => false);
          break;
        }
      case true:
        {
          log("1");
          _saveIsFirstTimeAppUseCase.saveIsFirstTime();
          Navigator.pushNamedAndRemoveUntil(
              context, RoutePaths.welcome, (route) => false);
          break;
        }
      case false:
        {
          log("3");
          Navigator.pushNamedAndRemoveUntil(
              context, RoutePaths.logIn, (route) => false);
        }
    }
  }
}
