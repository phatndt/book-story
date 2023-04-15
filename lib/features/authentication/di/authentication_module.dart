import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/presentation/state.dart';
import '../data/repository/auth_repo_impl.dart';
import '../presentation/state/forgot_password_state.dart';
import '../presentation/state/login_state.dart';
import '../presentation/state/register_state.dart';

final authRepoProvider = Provider<AuthRepoImpl>((ref) => AuthRepoImpl());

final forgotPasswordStateNotifierProvider =
    StateNotifierProvider<ForgotPasswordStateNotifier, UIState>(
  (ref) => ForgotPasswordStateNotifier(ref, ref.read(authRepoProvider)),
);

final loginStateNotifierProvider =
    StateNotifierProvider.autoDispose<LoginStateNotifier, UIState>(
        ((ref) => LoginStateNotifier(ref, ref.watch(authRepoProvider))));

final registerStateNotifierProvider =
    StateNotifierProvider<RegisterStateNotifier, UIState>(
  ((ref) => RegisterStateNotifier(ref, ref.watch(authRepoProvider))),
);
