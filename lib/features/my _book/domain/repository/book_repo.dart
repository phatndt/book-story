import 'package:book_story/features/my%20_book/data/model/book_model.dart';
import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:dartz/dartz.dart';

abstract class BookRepo {
  Future<Either<Exception, String>> addBook(
    String name,
    String author,
    String description,
    String image,
    String language,
    String category,
    String createDate,
    String userId,
  );

  Future<Either<Exception, List<BookModel>>> getBooksByUser(String userId);
}
