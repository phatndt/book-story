import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';
import '../../domain/repository/profile_repo.dart';

class ChangePasswordState extends StateNotifier<UIState> {
  ChangePasswordState(this._profileRepo) : super(UIInitialState());
  final ProfileRepo _profileRepo;

  changePassword(String oldPassword, String newPassword) async {
    state = const UILoadingState(true);
    final result =
        await _profileRepo.updateProfilePassword(oldPassword, newPassword);
    state = const UILoadingState(false);
    result.fold(
      (l) => state = UIErrorState(l),
      (r) => state = UISuccessState('change_password_successfully'.tr()),
    );
  }
}
