import 'package:book_exchange/domain/use_cases/change_information/change_address_use_case.dart';
import 'package:book_exchange/domain/use_cases/change_information/change_address_use_case_impl.dart';
import 'package:book_exchange/domain/use_cases/change_information/change_avatar_path_use_case_impl.dart';
import 'package:book_exchange/presentation/view_models/change_information_viewmodels.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/repos/profile_repo_impl.dart';
import '../../data/services/profile_service.dart';
import '../../domain/use_cases/change_information/change_username_use_case_impl.dart';
import '../../domain/use_cases/change_password_use_case_impl.dart';
import '../view_models/changing_password_view_model.dart';

final profileServiceProvider =
    Provider<ProfileService>((ref) => ProfileService());

final profileRepoProvider = Provider<ProfileRepoImpl>(
    (ref) => ProfileRepoImpl(ref.watch(profileServiceProvider)));

final changePasswordUserCaseProvider = Provider<ChangePasswordUseCaseImpl>(
    (ref) => ChangePasswordUseCaseImpl(ref.watch(profileRepoProvider)));

final changingPasswordNotifierProvider =
    StateNotifierProvider<ChangingPasswordNotifier, ChangingPasswordSetting>(
        ((ref) => ChangingPasswordNotifier(
            ref, ref.watch(changePasswordUserCaseProvider))));

// final changeAdressUseCaseProvider = Provider<ChangeAdressUseCaseImpl>(
//     (ref) => ChangeAdressUseCaseImpl(ref.watch(profileRepoProvider)));

// final changeUsernameUseCaseProvider = Provider<ChangeUsernameUseCaseImpl>(
//     (ref) => ChangeUsernameUseCaseImpl(ref.watch(profileRepoProvider)));

// final changeAvatarPathUseCaseProvider = Provider<ChangeAvatarPathUseCaseImpl>(
//     (ref) => ChangeAvatarPathUseCaseImpl(ref.watch(profileRepoProvider)));

// final changeInformationNotifierProvider = StateNotifierProvider<
//         ChangeInformationSettingNotifier, ChangeInformationSetting>(
//     (ref) => ChangeInformationSettingNotifier(
//         ref,
//         ref.watch(changeAdressUseCaseProvider),
//         ref.watch(changeAvatarPathUseCaseProvider),
//         ref.watch(changeUsernameUseCaseProvider)));
