import 'package:book_story/features/profile/domain/repository/profile_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';

class ProfileState extends StateNotifier<UIState> {
  ProfileState(this._profileRepo) : super(UIInitialState());
  final ProfileRepo _profileRepo;


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

  signOut() {
    _profileRepo.logOut();
  }
}

class UIGetProfilePhotoUrlSuccessState extends UIState {
  final String message;

  const UIGetProfilePhotoUrlSuccessState(this.message);
}

class UIGetProfileNameSuccessState extends UIState {
  final String name;

  const UIGetProfileNameSuccessState(this.name);
}
