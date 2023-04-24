import 'dart:io';

import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';

class GetBookDetailStateNotifier extends StateNotifier<UIState> {
  GetBookDetailStateNotifier(this.ref, this._bookRepo)
      : super(UIInitialState());

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

  addReadFileOfBook(String bookId, File readFile) {
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIStateError(Exception("User is null. Please login again!"));
      return;
    }
    state = const UIStateLoading(true);
    _bookRepo
        .uploadReadFileBookToFirebaseStorageStream(
            FirebaseAuth.instance.currentUser!.uid, bookId, readFile)
        .listen((event) {
      event.fold((l) {
        state = const UIStateLoading(false);
        state = UIStateError(l);
      }, (r) async {
        if (r.state == TaskState.running) {
          state = UpdateReadFileOfBookLoading(
              (r.bytesTransferred / r.totalBytes * 100));
        } else if (r.state == TaskState.success) {
          final path = await r.ref.getDownloadURL();
          updateReadFileAttributeOfBook(
              FirebaseAuth.instance.currentUser!.uid, bookId, path);
        } else if (r.state == TaskState.error) {
          state = const UIStateLoading(false);
          state = UIStateError(Exception("Upload file error!"));
        }
      });
    });
  }

  updateReadFileAttributeOfBook(
    String userId,
    String bookId,
    String readFilePath,
  ) {
    _bookRepo
        .updateReadFileOfBook(
      userId,
      bookId,
      readFilePath,
    )
        .then((value) {
      state = const UIStateLoading(false);
      value.fold(
        (l) => state = UIStateError(Exception("Upload file error!")),
        (r) => state = const UpdateReadFileOfBookSuccess(),
      );
    });
  }

  deleteBook(String bookId) {
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIStateError(Exception("User is null. Please login again!"));
      return;
    }
    state = const UIStateLoading(true);
    _bookRepo.deleteBook(FirebaseAuth.instance.currentUser!.uid, bookId).then(
          (value) {
            state = const UIStateLoading(false);
            value.fold(
                  (l) => state = UIStateError(l),
                  (r) => state = const DeleteBookSuccess(),
            );
          }
        );
  }
}

class UpdateReadFileOfBookLoading extends UIState {
  final double percentage;

  const UpdateReadFileOfBookLoading(this.percentage) : super();
}

class UpdateReadFileOfBookSuccess extends UIState {
  const UpdateReadFileOfBookSuccess() : super();
}

class DeleteBookSuccess extends UIState {
  const DeleteBookSuccess() : super();
}
