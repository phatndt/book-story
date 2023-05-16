import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
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
}

class UISuccessLoadBookList extends UIState {
  const UISuccessLoadBookList(this.bookList) : super();
  final List<Book> bookList;
}
