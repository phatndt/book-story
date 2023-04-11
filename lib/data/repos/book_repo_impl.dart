import 'dart:io';

import 'package:book_exchange/data/services/book_service.dart';
import 'package:book_exchange/domain/entities/book.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/repository/book_repo.dart';

import '../mapper/book_mapper.dart';

class BookRepoImpl extends BookRepo {
  final BookService _bookService;

  BookRepoImpl(this._bookService);

  @override
  Future<String?> updateImageToSpaces(
    String path,
    File file,
  ) async {
    return await _bookService.uploadImageToSpaces(path, file);
  }

  @override
  Future<ApiResponse<Book>> deleteBook(String bookId, String token) async {
    return await _bookService.deleteBook(bookId, token).then(
          (value) => ApiResponseBookMapper().transfer(value),
        );
  }

  @override
  Future<ApiResponse<Book>> editBook(Book book, String token) async {
    return await _bookService.editBook(book, token).then(
          (value) => ApiResponseBookMapper().transfer(value),
        );
  }

  @override
  Future<ApiResponse<List<Book>>> getBooksByUserId(String token) async {
    return await _bookService.getBooksByUserId(token).then(
          (value) => ApiResponseBookListMapper().transfer(value),
        );
  }

  @override
  Future<ApiResponse<Book>> uploadBook(Book book, String token) async {
    return _bookService.uploadBook(book, token).then(
          (value) => ApiResponseBookMapper().transfer(value),
        );
  }
}
