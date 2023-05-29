import 'package:book_story/core/presentation/state.dart';
import 'package:book_story/features/my%20_book/di/my_book_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../my_book_shelf/di/book_shelf_module.dart';
import '../data/repository/profile_repo_impl.dart';
import '../domain/repository/profile_repo.dart';
import '../presentation/state/change_password_state.dart';
import '../presentation/state/edit_profile_state.dart';
import '../presentation/state/profile_state.dart';

final profileRepoProvider = Provider<ProfileRepo>((ref) => ProfileRepoImpl());

final profileStateNotifierProvider =
    StateNotifierProvider<ProfileState, UIState>((ref) {
  final profileRepo = ref.watch(profileRepoProvider);
  return ProfileState(
    profileRepo,
    ref.watch(bookRepoProvider),
    ref.watch(bookShelfRepoProvider),
  );
});

final editProfileStateNotifierProvider =
    StateNotifierProvider<EditProfileState, UIState>((ref) {
  final profileRepo = ref.watch(profileRepoProvider);
  return EditProfileState(profileRepo);
});

final changePasswordStateNotifierProvider =
    StateNotifierProvider<ChangePasswordState, UIState>((ref) {
  final profileRepo = ref.watch(profileRepoProvider);
  return ChangePasswordState(profileRepo);
});
