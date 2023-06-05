import 'package:book_story/features/authentication/domain/repository/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';

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
          state = UIErrorState(l);
        },
        (r) {
          state = UISuccessState(r);
        },
      );
    } else {
      state = UIErrorState(Exception('Please enter your email and password!'));
    }
  }
}