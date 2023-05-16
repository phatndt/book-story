import 'package:book_story/features/my_book_shelf/data/datasource/local/book_shelf_adapter.dart';
import 'package:book_story/features/my_book_shelf/data/datasource/local/book_shelf_dao.dart';
import 'package:book_story/features/my_book_shelf/data/repostiory/book_shelf_repo_impl.dart';
import 'package:book_story/features/my_book_shelf/domain/repository/book_shelf_repo.dart';
import 'package:book_story/features/my_book_shelf/presentation/state/book_shelf_state.dart';
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

final addBookShelfNotifierProvider = StateNotifierProvider<AddBookShelfState, UIState>((ref) {
  return AddBookShelfState(ref.read(bookShelfRepoProvider));
});

final searchBookShelfNotifierProvider = StateNotifierProvider<SearchBookShelfState, UIState>((ref) {
  return SearchBookShelfState(ref.read(bookShelfRepoProvider));
});

final bookShelfDetailStateNotifierProvider = StateNotifierProvider<BookShelfDetailState, UIState>((ref) {
  return BookShelfDetailState(ref, ref.read(bookShelfRepoProvider), ref.read(bookRepoProvider));
});