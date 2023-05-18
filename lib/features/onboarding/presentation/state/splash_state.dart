import 'dart:developer';

import 'package:book_story/features/onboarding/domain/usecase/check_logged_use_case.dart';
import 'package:book_story/features/onboarding/domain/usecase/get_is_first_time_app.dart';
import 'package:book_story/features/onboarding/domain/usecase/save_is_first_time_app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/presentation/state.dart';




class SplashStateNotifier extends StateNotifier<UIState> {
  SplashStateNotifier(this.ref, this._getIsFirstTimeAppUseCase,
      this._saveIsFirstTimeAppUseCase, this._checkLoggedUseCase) : super(UIInitialState());

  final Ref ref;
  final GetIsFirstTimeAppUseCase _getIsFirstTimeAppUseCase;
  final SaveIsFirstTimeAppUseCase _saveIsFirstTimeAppUseCase;
  final CheckLoggedUseCase _checkLoggedUseCase;

  init() async {
    bool? isFirstTime = await _getIsFirstTimeAppUseCase.getIsFirstTimeApp();
    switch (isFirstTime) {
      case null:
        {
          state = const UIFirstTimeState();
          break;
        }
      case true:
        {
          state = const UIFirstTimeState();
          break;
        }
      case false:
        {
          final result = await _checkLoggedUseCase.checkLogged();
          result.fold(
            (l) {
              state = const UINotLoggedState();
            },
            (r) {
              if (r) {
                state = const UILoggedState();
              } else {
                state = const UINotLoggedState();
              }
            },
          );
        }
    }
  }

  void saveIsFirstTime() {
    _saveIsFirstTimeAppUseCase.saveIsFirstTime();
  }
}

class UIFirstTimeState extends UIState {
  const UIFirstTimeState() : super();
}

class UILoggedState extends UIState {
  const UILoggedState() : super();
}

class UINotLoggedState extends UIState {
  const UINotLoggedState() : super();
}
