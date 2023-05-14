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
    String releaseDate,
    String category,
    String? image,
  ) {
    if (image == null) {
      state = UIErrorState(Exception("Image is empty"));
      return;
    }
    state = const UILoadingState(true);
    _bookRepo
        .addBook(
      name,
      author,
      description,
      image,
      language,
      releaseDate,
      category,
      DateTime.now().toString(),
      FirebaseAuth.instance.currentUser?.uid ?? "",
    )
        .then(
      (value) {
        state = const UILoadingState(false);
        value.fold(
          (l) {
            state = UIErrorState(l);
          },
          (r) {
            state = UISuccessState(r);
          },
        );
      },
    );
  }
}
