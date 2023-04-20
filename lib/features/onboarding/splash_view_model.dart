import 'dart:developer';

import 'package:book_story/core/navigation/route_paths.dart';
import 'package:book_story/domain/use_cases/main/get_is_first_time_app.dart';
import 'package:book_story/domain/use_cases/main/save_is_first_time_app.dart';
import 'package:book_story/features/authentication/domain/repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashProvider {
  SplashProvider(this.ref, this._getIsFirstTimeAppUseCase,
      this._saveIsFirstTimeAppUseCase, this._authRepo);

  final Ref ref;
  final GetIsFirstTimeAppUseCase _getIsFirstTimeAppUseCase;
  final SaveIsFirstTimeAppUseCase _saveIsFirstTimeAppUseCase;
  final AuthRepo _authRepo;

  init(context) async {
    bool? isFirstTime = await _getIsFirstTimeAppUseCase.getIsFirstTimeApp();
    switch (isFirstTime) {
      case null:
        {
          _saveIsFirstTimeAppUseCase.saveIsFirstTime();
          Navigator.pushNamedAndRemoveUntil(
              context, RoutePaths.welcome, (route) => false);
          break;
        }
      case true:
        {
          _saveIsFirstTimeAppUseCase.saveIsFirstTime();
          Navigator.pushNamedAndRemoveUntil(
              context, RoutePaths.welcome, (route) => false);
          break;
        }
      case false:
        {
          final result = await _authRepo.checkLogged();
          result.fold(
            (l) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutePaths.logIn, (route) => false);
            },
            (r) {
              if (r) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RoutePaths.main, (route) => false);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, RoutePaths.logIn, (route) => false);
              }
            },
          );
        }
    }
  }
}
