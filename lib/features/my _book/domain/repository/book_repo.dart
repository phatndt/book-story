import 'dart:io';

import 'package:book_story/features/my%20_book/data/model/book_model.dart';
import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class BookRepo {
  Future<Either<Exception, String>> addBook(
    String name,
    String author,
    String description,
    String image,
    String language,
    String releaseDate,
    String category,
    String createDate,
    String userId,
  );

  Future<Either<Exception, List<BookModel>>> getBooksByUser(String userId);

  Future<Either<Exception, BookModel>> getBookDetail(
      String userId, String bookId);

  Future<Either<Exception, bool>> updateReadFileOfBook(
      String userId, String bookId, String readFilePath);

  Stream<Either<Exception, TaskSnapshot>>
      uploadReadFileBookToFirebaseStorageStream(
          String userId, String bookId, File readFile);

  Future<Either<Exception, bool>> updateReadFilePageBook(
      String userId, String bookId, int page);

  Future<Either<Exception, bool>> deleteBook(
      String userId, String bookId);

  Future<Either<Exception, String>> uploadImage(
      String userId, String bookId, File image);

  Future<Either<Exception, bool>> editBook(
      String bookId,
      String name,
      String author,
      String description,
      String image,
      String language,
      String releaseDate,
      String category,
      String userId,
      );
  Future<Either<Exception, List<BookModel>>> getBookListByBookShelf(
      String userId, String bookShelfId, List<String> booksId);
}
