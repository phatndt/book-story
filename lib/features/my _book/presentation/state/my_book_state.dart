import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';

class MyBookStateNotifier extends StateNotifier<UIState> {
  MyBookStateNotifier(this.ref, this._bookRepo) : super(UIInitialState());

  final Ref ref;
  final BookRepo _bookRepo;

  getBook() {
    state = const UIStateLoading(true);
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIStateError(Exception("User is null. Please login again!"));
      return;
    }
    _bookRepo.getBooksByUser(FirebaseAuth.instance.currentUser!.uid).then(
      (value) {
        state = const UIStateLoading(false);
        value.fold(
          (l) {
            state = UIStateError(l);
          },
          (r) {
            state = UIStateSuccess(r.map((e) => Book.fromModel(e)).toList());
          },
        );
      },
    );
  }
}
