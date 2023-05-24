import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my_book_shelf/data/datasource/local/book_shelf_adapter.dart';
import 'package:book_story/features/my_book_shelf/data/datasource/local/book_shelf_dao.dart';
import 'package:book_story/features/my_book_shelf/data/repostiory/book_shelf_repo_impl.dart';
import 'package:book_story/features/my_book_shelf/domain/repository/book_shelf_repo.dart';
import 'package:book_story/features/my_book_shelf/presentation/state/add_book_to_shelf_state.dart';
import 'package:book_story/features/my_book_shelf/presentation/state/book_shelf_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/presentation/state.dart';
import '../../my _book/di/my_book_module.dart';
import '../presentation/state/add_book_shelf_state.dart';
import '../presentation/state/book_shelf_detail_state.dart';
import '../presentation/state/search_book_shelf_state.dart';

final bookShelfDao = Provider<BookShelfDao>((ref) {
  return BookShelfDao();
});

final bookShelfRepoProvider = Provider<BookShelfRepo>((ref) {
  return BookShelfRepoImpl(ref.watch(bookShelfDao));
});

final bookShelfStateNotifierProvider =
    StateNotifierProvider<BookShelfState, UIState>((ref) {
  return BookShelfState(ref, ref.read(bookShelfRepoProvider));
});

final addBookShelfNotifierProvider =
    StateNotifierProvider<AddBookShelfState, UIState>((ref) {
  return AddBookShelfState(ref.read(bookShelfRepoProvider));
});

final searchBookShelfNotifierProvider =
    StateNotifierProvider<SearchBookShelfState, UIState>((ref) {
  return SearchBookShelfState(ref.read(bookShelfRepoProvider));
});

final bookShelfDetailStateNotifierProvider =
    StateNotifierProvider<BookShelfDetailState, UIState>((ref) {
  return BookShelfDetailState(
      ref, ref.read(bookShelfRepoProvider), ref.read(bookRepoProvider));
});

final addBookToShelfNotifierProvider =
    StateNotifierProvider<AddBookToShelfStateNotifier, UIState>((ref) {
  return AddBookToShelfStateNotifier(
      ref, ref.read(bookRepoProvider), ref.read(bookShelfRepoProvider));
});

final getBooksByUserFutureProvider =
    FutureProvider.autoDispose<List<Book>>((ref) async {
  if (FirebaseAuth.instance.currentUser == null) {
    return Future.error('user_is_null_login_again'.tr());
  }
  final result = await ref
      .watch(bookRepoProvider)
      .getBooksByUser(FirebaseAuth.instance.currentUser!.uid);
  if (result.isLeft()) {
    final error = result.fold((l) => Exception(l), (r) => null);
    return Future.error(error.toString());
  } else {
    final s = result.fold((l) => null, (r) => r)!;
    return Future.value(s.map((e) => Book.fromModel(e)).toList());
  }
});
