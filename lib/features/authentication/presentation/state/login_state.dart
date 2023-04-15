import 'package:book_story/features/authentication/domain/repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/presentation/state.dart';
import '../../../../domain/use_cases/auth/login_use_case.dart';

class LoginStateNotifier extends StateNotifier<UIState> {
  LoginStateNotifier(this.ref, this._authRepo)
      : super(
          UIInitialState(),
        );

  final Ref ref;
  final AuthRepo _authRepo;

  login(String email, String password) async {
    if (email.isNotEmpty || password.isNotEmpty) {
      final result = await _authRepo.login(email, password);
      result.fold(
        (l) {
          state = UIStateError(l);
        },
        (r) {
          state = UIStateSuccess(r);
        },
      );
    } else {
      state = UIStateError(Exception('Please enter your email and password!'));
    }
  }
}