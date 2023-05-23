import 'package:book_story/features/my_book_shelf/data/model/book_shelf_model.dart';
import 'package:dartz/dartz.dart';



abstract class BookShelfRepo {
  Future<Either<Exception, List<BookShelfModel>>> getBookShelfList(String userId);
  Future<Either<Exception, String>> addBookShelf(BookShelfModel bookShelfModel, String userId);
  Future<Either<Exception, List<BookShelfModel>>> getBookShelfListFromLocal();
  Future<Either<Exception, BookShelfModel>> getBookShelfById(String userId, String bookShelfId);
  Future<Either<Exception, bool>> deleteBookShelf(String userId, String bookShelfId);
  Future<Either<Exception, bool>> updateBookShelf(String userId, String bookShelfId, String name, String color);
}