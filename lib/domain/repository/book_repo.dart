import 'dart:io';

import '../entities/api_response.dart';
import '../entities/book.dart';

abstract class BookRepo {
  Future<String?> updateImageToSpaces(
    String path,
    File file,
  );

  Future<ApiResponse<List<Book>>> getBooksByUserId(String token);
  Future<ApiResponse<Book>> uploadBook(Book book, String token);
  Future<ApiResponse<Book>> editBook(Book book, String token);
  Future<ApiResponse<Book>> deleteBook(String bookId, String token);
}
