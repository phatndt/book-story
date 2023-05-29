import 'package:book_story/features/my%20_book/data/model/book_model.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:book_story/features/my_book_shelf/data/model/book_shelf_model.dart';
import 'package:book_story/features/profile/domain/repository/profile_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';
import '../../../my_book_shelf/domain/repository/book_shelf_repo.dart';

class ProfileState extends StateNotifier<UIState> {
  ProfileState(this._profileRepo, this._bookRepo, this._bookShelfRepo)
      : super(UIInitialState());
  final ProfileRepo _profileRepo;
  final BookRepo _bookRepo;
  final BookShelfRepo _bookShelfRepo;

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

  getProfileInformation() async {
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIErrorState(Exception('user_is_null_login_again'.tr()));
      return;
    }
    state = const UILoadingState(true);
    final result = await Future.wait(
      [
        _bookRepo.getBooksByUser(FirebaseAuth.instance.currentUser!.uid),
        _bookShelfRepo.getBookShelfList(FirebaseAuth.instance.currentUser!.uid)
      ],
    );
    final bookResult =
        await _bookRepo.getBooksByUser(FirebaseAuth.instance.currentUser!.uid);
    final bookShelfResult = await _bookShelfRepo
        .getBookShelfList(FirebaseAuth.instance.currentUser!.uid);
    state = const UILoadingState(false);
    bookResult.fold(
      (l) => state = UIErrorState(l),
      (r) {
        state = UIBookListSuccessState(r.length);
        state = UIPDFSuccessState(
          r.where((element) => element.readFile.isNotEmpty).toList().length,
        );
      },
    );
    bookShelfResult.fold(
      (l) => state = UIErrorState(l),
      (r) {
        state = UIBookShelfSuccessState(r.length);
      },
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

class UIBookListSuccessState extends UIState {
  final int length;

  const UIBookListSuccessState(this.length);
}

class UIBookShelfSuccessState extends UIState {
  final int length;

  const UIBookShelfSuccessState(this.length);
}

class UIPDFSuccessState extends UIState {
  final int length;

  const UIPDFSuccessState(this.length);
}
