import 'dart:io';

import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';

class EditBookStateNotifier extends StateNotifier<UIState> {
  EditBookStateNotifier(this.ref, this._bookRepo) : super(UIInitialState());

  final Ref ref;
  final BookRepo _bookRepo;
  late Book? book;

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
            book = Book.fromModel(r);
            state = UIStateSuccess(Book.fromModel(r));
          },
        );
      },
    );
  }

  editBook(
    String name,
    String author,
    String description,
    String language,
    String releaseDate,
    String category,
    String? image,
  ) {
    if (image == null) {
      state = UIStateError(Exception("Image is empty"));
      return;
    }
    if (book!.name == name &&
        book!.author == author &&
        book!.description == description &&
        book!.releaseDate == releaseDate &&
        book!.category == category &&
        book!.language == language &&
        book!.image == image) {
      state = const UIStateWarning("Nothing to update");
      return;
    }
    state = const UIStateLoading(true);
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIStateError(Exception("User is null. Please login again!"));
      return;
    }
    if (image != book!.image) {
      _bookRepo
          .uploadImage(
              FirebaseAuth.instance.currentUser!.uid, book!.id, File(image))
          .then(
            (value) => value.fold(
              (l) => state = EditBookError(l),
              (r) => _bookRepo
                  .editBook(
                      book!.id,
                      name,
                      author,
                      description,
                      r,
                      language,
                      releaseDate,
                      category,
                      FirebaseAuth.instance.currentUser!.uid)
                  .then(
                    (value) => value.fold(
                      (l) => state = EditBookError(l),
                      (r) => state = const EditBookSuccess(),
                    ),
                  ),
            ),
          );
    } else  {
      _bookRepo
          .editBook(
          book!.id,
          name,
          author,
          description,
          image,
          language,
          releaseDate,
          category,
          FirebaseAuth.instance.currentUser!.uid)
          .then(
            (value) => value.fold(
              (l) => state = EditBookError(l),
              (r) => state = const EditBookSuccess(),
        ),
      );
    }
  }
}

class EditBookError extends UIState {
  final Exception e;

  const EditBookError(this.e) : super();
}

class EditBookSuccess extends UIState {
  const EditBookSuccess() : super();
}
