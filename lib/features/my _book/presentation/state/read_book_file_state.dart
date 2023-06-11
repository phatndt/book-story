import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';

class ReadBookFileStateNotifier extends StateNotifier<UIState> {
  ReadBookFileStateNotifier(this.ref, this._bookRepo) : super(UIInitialState());

  final Ref ref;
  final BookRepo _bookRepo;

  getBookDetail(String bookId) {
    state = const UILoadingState(true);
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIErrorState(Exception('user_is_null_login_again'.tr()));
      return;
    }
    _bookRepo
        .getBookDetail(FirebaseAuth.instance.currentUser!.uid, bookId)
        .then(
          (value) {
        state = const UILoadingState(false);
        value.fold(
              (l) {
            state = UIErrorState(l);
          },
              (r) {
            state = UISuccessState(Book.fromModel(r));
          },
        );
      },
    );
  }

  updateReadFilePageBook(String bookId, int currentPage) async {
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIErrorState(Exception('user_is_null_login_again'.tr()));
      return;
    }
    await _bookRepo.updateReadFilePageBook(FirebaseAuth.instance.currentUser!.uid, bookId, currentPage);
  }
}