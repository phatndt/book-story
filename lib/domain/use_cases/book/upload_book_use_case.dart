import '../../entities/api_response.dart';
import '../../entities/book.dart';

abstract class UploadBookUseCase {
  Future<ApiResponse<Book>> uploadBook(Book book, String token);
}