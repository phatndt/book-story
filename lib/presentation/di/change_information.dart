import 'package:book_exchange/presentation/di/profile_component.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/use_cases/change_information/change_address_use_case_impl.dart';
import '../../domain/use_cases/change_information/change_avatar_path_use_case_impl.dart';
import '../../domain/use_cases/change_information/change_username_use_case_impl.dart';
import '../view_models/change_information_viewmodels.dart';
import 'changing_password_component.dart';

final changeAdressUseCaseProvider = Provider<ChangeAdressUseCaseImpl>(
    (ref) => ChangeAdressUseCaseImpl(ref.watch(profileRepoProvider)));

final changeUsernameUseCaseProvider = Provider<ChangeUsernameUseCaseImpl>(
    (ref) => ChangeUsernameUseCaseImpl(ref.watch(profileRepoProvider)));

final changeAvatarPathUseCaseProvider = Provider<ChangeAvatarPathUseCaseImpl>(
    (ref) => ChangeAvatarPathUseCaseImpl(ref.watch(profileRepoProvider)));

final changeInformationNotifierProvider = StateNotifierProvider<
    ChangeInformationSettingNotifier, ChangeInformationSetting>(
  (ref) => ChangeInformationSettingNotifier(
    ref,
    ref.watch(changeAdressUseCaseProvider),
    ref.watch(changeUsernameUseCaseProvider),
    ref.watch(getUserUseCase),
  ),
);
