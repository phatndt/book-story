import 'package:book_story/core/presentation/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repository/auth_repo.dart';

class RegisterStateNotifier extends StateNotifier<UIState> {
  RegisterStateNotifier(this.ref, this._authRepo)
      : super(UIInitialState());

  final Ref ref;
  final AuthRepo _authRepo;

  register(email, password, username) async {
    final result = await _authRepo.register(username, password, email);
    result.fold(
      (l) {
        state = UIErrorState(l);
      },
      (r) {
        state = UISuccessState(r);
      },
    );
  }
}
