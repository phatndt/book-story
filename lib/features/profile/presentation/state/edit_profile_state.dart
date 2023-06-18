import 'dart:io';

import 'package:book_story/features/profile/domain/repository/profile_repo.dart';
import 'package:book_story/features/profile/presentation/state/profile_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';

class EditProfileState extends StateNotifier<UIState> {
  EditProfileState(this._profileRepo) : super(UIInitialState());
  final ProfileRepo _profileRepo;

  updateProfilePhotoUrl(String url) async {
    state = const UILoadingState(true);
    final result = await _profileRepo.updateProfilePhotoUrl(File(url));
    state = const UILoadingState(false);
    result.fold(
      (l) => state = UIErrorState(l),
      (r) => state = UIUpdateProfilePhotoUrlSuccessState(
        'update_profile_photo_url'.tr(),
      ),
    );
  }

  getProfilePhoto() async {
    state = const UILoadingState(true);
    final result = await _profileRepo.getProfilePhotoUrl();
    state = const UILoadingState(false);
    result.fold(
      (l) => state = UIErrorState(l),
      (r) => state = UIGetProfilePhotoUrlSuccessState(r),
    );
  }

  getProfileName() async {
    state = const UILoadingState(true);
    final result = await _profileRepo.getProfileName();
    state = const UILoadingState(false);
    result.fold(
      (l) => state = UIErrorState(l),
      (r) => state = UIGetProfileNameSuccessState(r),
    );
  }

  updateProfileName(String name) async {
    state = const UILoadingState(true);
    final result = await _profileRepo.updateProfileName(name);
    state = const UILoadingState(false);
    result.fold(
      (l) => state = UIErrorState(l),
      (r) => state = UIUpdateProfileNameSuccessState(
        'update_profile_name_successfully'.tr(),
      ),
    );
  }

  updateProfile(String? photoUrl, String oldName, String newName) async {
    if (newName == oldName && photoUrl == null) {
      state = UIErrorState(Exception('same_display_name'.tr()));
    } else if (newName == oldName && photoUrl != null) {
      updateProfilePhotoUrl(photoUrl);
    } else if (newName != oldName && photoUrl == null) {
      updateProfileName(newName);
    } else {
      state = const UILoadingState(true);
      final result = await Future.wait([
        _profileRepo.updateProfileName(newName),
        _profileRepo.updateProfilePhotoUrl(
          File(photoUrl!),
        )
      ]);

      state = const UILoadingState(false);
      bool isSuccess = false;
      for (var element in result) {
        element.fold(
          (l) {
            state = UIErrorState(l);
            isSuccess = false;
          },
          (r) => isSuccess = true,
        );
      }
      if (isSuccess) {
        state = UISuccessState('update_profile_successfully'.tr());
      }
    }
  }

  getEmail() async {
    state = const UILoadingState(true);
    final result = await _profileRepo.getEmail();
    state = const UILoadingState(false);
    result.fold(
      (l) => state = UIErrorState(l),
      (r) => state = UIGetEmailSuccessState(r),
    );
  }
}

class UIUpdateProfilePhotoUrlSuccessState extends UIState {
  final String message;

  const UIUpdateProfilePhotoUrlSuccessState(this.message);
}

class UIGetProfilePhotoUrlSuccessState extends UIState {
  final String message;

  const UIGetProfilePhotoUrlSuccessState(this.message);
}

class UIGetProfileNameSuccessState extends UIState {
  final String name;

  const UIGetProfileNameSuccessState(this.name);
}

class UIUpdateProfileNameSuccessState extends UIState {
  final String message;

  const UIUpdateProfileNameSuccessState(this.message);
}

class UIGetEmailSuccessState extends UIState {
  final String email;

  const UIGetEmailSuccessState(this.email);
}
