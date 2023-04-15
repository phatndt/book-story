import 'package:book_story/core/presentation/state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        state = UIStateError(l);
      },
      (r) {
        state = UIStateSuccess(r);
      },
    );
  }
}
