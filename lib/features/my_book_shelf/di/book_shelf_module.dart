import 'package:book_story/features/my_book_shelf/data/repostiory/book_shelf_repo_impl.dart';
import 'package:book_story/features/my_book_shelf/domain/repository/book_shelf_repo.dart';
import 'package:book_story/features/my_book_shelf/presentation/state/book_shelf_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/presentation/state.dart';

final bookRepoProvider = Provider<BookShelfRepo>((ref) {
  return BookShelfRepoImpl();
});

final bookShelfStateNotifierProvider =
StateNotifierProvider<BookShelfState, UIState>((ref) {
  return BookShelfState(ref, ref.read(bookRepoProvider));
});