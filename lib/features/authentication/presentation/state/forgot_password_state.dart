

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';
import '../../domain/repository/auth_repo.dart';

class ForgotPasswordStateNotifier extends StateNotifier<UIState> {
  ForgotPasswordStateNotifier(this.ref, this._authRepo)
      : super(
    UIInitialState(),
  );

  final Ref ref;
  final AuthRepo _authRepo;

  resetPassword(String email) async {
    if (email.isNotEmpty) {
      final result = await _authRepo.resetPassword(email);
      result.fold(
            (l) {
          state = UIErrorState(l);
        },
            (r) {
          state = UISuccessState(r);
        },
      );
    } else {
      state = UIErrorState(Exception('Please enter your email!'));
    }
  }

}