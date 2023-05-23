import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';
import '../../domain/repository/book_shelf_repo.dart';

class BookShelfDetailState extends StateNotifier<UIState> {
  BookShelfDetailState(this.ref, this._bookShelfRepo, this._bookRepo)
      : super(UIInitialState());

  final Ref ref;
  final BookShelfRepo _bookShelfRepo;
  final BookRepo _bookRepo;

  Future<void> getBookShelfList(
      String bookShelfId) async {
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIErrorState(Exception("User is null. Please login again!"));
      return;
    }
    state = const UILoadingState(true);
    final result = await _bookShelfRepo.getBookShelfById(
        FirebaseAuth.instance.currentUser!.uid, bookShelfId);
    result.fold((l) {
      state = UIErrorState(l);
    }, (r) {
      state = UISuccessState(r.toEntity());
      getBookListByListBookShelf(bookShelfId, r.booksList);
    });
  }

  Future<void> getBookListByListBookShelf(
      String bookShelfId, List<String> booksId) async {
    if (booksId.isEmpty) {
      state = const UILoadingState(false);
      state = const UISuccessLoadBookList([]);
      return;
    }
    final result = await _bookRepo.getBookListByBookShelf(
        FirebaseAuth.instance.currentUser!.uid, bookShelfId, booksId);
    state = const UILoadingState(false);
    result.fold((l) {
      state = UIErrorState(l);
    }, (r) {
      state = UISuccessLoadBookList(r.map((e) => Book.fromModel(e)).toList());
    });
  }

  void deleteBookShelf(String bookShelfId) async {
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIErrorState(Exception("User is null. Please login again!"));
      return;
    }
    state = const UILoadingState(true);
    final result = await _bookShelfRepo.deleteBookShelf(
        FirebaseAuth.instance.currentUser!.uid, bookShelfId);
    state = const UILoadingState(false);
    result.fold((l) {
      state = UIErrorState(l);
    }, (r) {
      state = UIDeleteBookShelfSuccessState('delete_book_shelf_success'.tr());
    });
  }

  void editBookShelf(String bookShelfId, String name, String color) async {
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIErrorState(Exception('user_is_null_login_again'.tr()));
      return;
    }
    state = const UILoadingState(true);
    final result = await _bookShelfRepo.updateBookShelf(
        FirebaseAuth.instance.currentUser!.uid, bookShelfId, name, color);
    state = const UILoadingState(false);
    result.fold((l) {
      state = UIErrorState(l);
    }, (r) {
      state = UIUpdateBookShelfSuccessState('update_book_shelf_success'.tr());
    });
  }
}

class UISuccessLoadBookList extends UIState {
  const UISuccessLoadBookList(this.bookList) : super();
  final List<Book> bookList;
}

class UIDeleteBookShelfSuccessState extends UIState {
  const UIDeleteBookShelfSuccessState(this.message) : super(); final String message;
}

class UIUpdateBookShelfSuccessState extends UIState {
  const UIUpdateBookShelfSuccessState(this.message) : super(); final String message;
}


