import 'package:book_story/features/my_book_shelf/data/model/book_shelf_model.dart';
import 'package:dartz/dartz.dart';


abstract class BookShelfRepo {
  Future<Either<Exception, List<BookShelfModel>>> getBookShelfList(String userId);
}