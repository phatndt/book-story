import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';

class AddBookStateNotifier extends StateNotifier<UIState> {
  AddBookStateNotifier(this.ref, this._bookRepo) : super(UIInitialState());

  final Ref ref;
  final BookRepo _bookRepo;

  addBook(
    String name,
    String author,
    String description,
    String language,
    String category,
    String? image,
  ) {
    if (image == null) {
      state = UIStateError(Exception("Image is null"));
      return;
    }
    state = const UIStateLoading(true);
    _bookRepo
        .addBook(
      name,
      author,
      description,
      image,
      language,
      category,
      DateTime.now().toString(),
      FirebaseAuth.instance.currentUser?.uid ?? "",
    )
        .then(
      (value) {
        state = const UIStateLoading(false);
        value.fold(
          (l) {
            state = UIStateError(l);
          },
          (r) {
            state = UIStateSuccess(r);
          },
        );
      },
    );
  }
}
