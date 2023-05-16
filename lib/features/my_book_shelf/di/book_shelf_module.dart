import 'package:book_story/features/my_book_shelf/data/datasource/local/book_shelf_adapter.dart';
import 'package:book_story/features/my_book_shelf/data/datasource/local/book_shelf_dao.dart';
import 'package:book_story/features/my_book_shelf/data/repostiory/book_shelf_repo_impl.dart';
import 'package:book_story/features/my_book_shelf/domain/repository/book_shelf_repo.dart';
import 'package:book_story/features/my_book_shelf/presentation/state/book_shelf_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/presentation/state.dart';
import '../presentation/state/add_book_shelf_state.dart';
import '../presentation/state/search_book_shelf_state.dart';

final bookShelfDao = Provider<BookShelfDao>((ref) {
  return BookShelfDao();
});


final bookRepoProvider = Provider<BookShelfRepo>((ref) {
  return BookShelfRepoImpl(ref.watch(bookShelfDao));
});

final bookShelfStateNotifierProvider =
StateNotifierProvider<BookShelfState, UIState>((ref) {
  return BookShelfState(ref, ref.read(bookRepoProvider));
});

final addBookShelfNotifierProvider = StateNotifierProvider<AddBookShelfState, UIState>((ref) {
  return AddBookShelfState(ref.read(bookRepoProvider));
});

final searchBookShelfNotifierProvider = StateNotifierProvider<SearchBookShelfState, UIState>((ref) {
  return SearchBookShelfState(ref.read(bookRepoProvider));
});