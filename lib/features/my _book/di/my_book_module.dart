import 'package:book_story/features/my%20_book/data/model/book_model.dart';
import 'package:book_story/features/my%20_book/data/repository/book_repo_impl.dart';
import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/presentation/state.dart';
import '../presentation/state/add_book_state.dart';
import '../presentation/state/my_book_state.dart';

final bookRepoProvider = Provider<BookRepo>((ref) {
  return BookRepoImpl();
});

final addBookStateNotifierProvider =
    StateNotifierProvider<AddBookStateNotifier, UIState>((ref) {
  return AddBookStateNotifier(ref, ref.read(bookRepoProvider));
});

final myBookStateNotifierProvider =
    StateNotifierProvider<MyBookStateNotifier, UIState>((ref) {
  return MyBookStateNotifier(ref, ref.read(bookRepoProvider));
});

final getBooksFutureProvider = FutureProvider.family<Either<Exception, List<BookModel>>, String>((ref, userId) async {
  return await ref.read(bookRepoProvider).getBooksByUser(userId);
});