import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';

class ReadBookFileStateNotifier extends StateNotifier<UIState> {
  ReadBookFileStateNotifier(this.ref, this._bookRepo) : super(UIInitialState());

  final Ref ref;
  final BookRepo _bookRepo;

  getBookDetail(String bookId) {
    state = const UIStateLoading(true);
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIStateError(Exception("User is null. Please login again!"));
      return;
    }
    _bookRepo
        .getBookDetail(FirebaseAuth.instance.currentUser!.uid, bookId)
        .then(
          (value) {
        state = const UIStateLoading(false);
        value.fold(
              (l) {
            state = UIStateError(l);
          },
              (r) {
            state = UIStateSuccess(Book.fromModel(r));
          },
        );
      },
    );
  }

  updateReadFilePageBook(String bookId, int currentPage) async {
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIStateError(Exception("User is null. Please login again!"));
      return;
    }
    await _bookRepo.updateReadFilePageBook(FirebaseAuth.instance.currentUser!.uid, bookId, currentPage);
  }
}