import 'package:book_story/features/my%20_book/data/model/book_model.dart';
import 'package:book_story/features/my%20_book/data/repository/book_repo_impl.dart';
import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:book_story/features/my%20_book/presentation/state/edit_book_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/presentation/state.dart';
import '../presentation/state/add_book_state.dart';
import '../presentation/state/book_detail_state.dart';
import '../presentation/state/my_book_state.dart';
import '../presentation/state/ocr_scan_state.dart';
import '../presentation/state/read_book_file_state.dart';

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

final getBookDetailStateNotifierProvider =
    StateNotifierProvider<GetBookDetailStateNotifier, UIState>((ref) {
  return GetBookDetailStateNotifier(ref, ref.read(bookRepoProvider));
});

final readBookFileStateNotifierProvider =
    StateNotifierProvider<ReadBookFileStateNotifier, UIState>((ref) {
  return ReadBookFileStateNotifier(ref, ref.read(bookRepoProvider));
});

final editBookStateNotifierProvider =
    StateNotifierProvider<EditBookStateNotifier, UIState>((ref) {
  return EditBookStateNotifier(ref, ref.read(bookRepoProvider));
});
final ocrScanStateNotifierProvider =
    StateNotifierProvider<OcrScanStateNotifier, UIState>((ref) {
  return OcrScanStateNotifier(ref);
});
