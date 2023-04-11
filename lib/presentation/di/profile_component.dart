import 'package:book_exchange/domain/use_cases/change_information/change_avatar_path_use_case.dart';
import 'package:book_exchange/domain/use_cases/change_information/change_avatar_path_use_case_impl.dart';
import 'package:book_exchange/domain/use_cases/profile/get_user_use_case.dart';
import 'package:book_exchange/domain/use_cases/profile/upload_avatar_use_case.dart';
import 'package:book_exchange/presentation/di/change_information.dart';
import 'package:book_exchange/presentation/di/changing_password_component.dart';
import 'package:book_exchange/presentation/view_models/change_information_viewmodels.dart';
import 'package:book_exchange/presentation/view_models/profile_view_model.dart';
import 'package:book_exchange/presentation/views/screens/profile/change_information.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final uploadAvatarToCloudUseCase = Provider<UploadAvatarUseCase>(
    (ref) => UploadAvatarUseCase(ref.watch(profileRepoProvider)));

final getUserUseCase = Provider<GetUserUseCase>(
  (ref) => GetUserUseCase(ref.watch(profileRepoProvider)),
);

final changeAvatarPathUseCase = Provider<ChangeAvatarPathUseCase>(
  (ref) => ChangeAvatarPathUseCaseImpl(
    ref.watch(profileRepoProvider),
  ),
);

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileSetting>(
  ((ref) => ProfileNotifier(
        ref,
        ref.watch(uploadAvatarToCloudUseCase),
        ref.watch(changeAvatarPathUseCase),
        ref.watch(getUserUseCase),
        ref.watch(changeAdressUseCaseProvider),
      )),
);
