import '../../entities/api_response.dart';
import '../../entities/book.dart';

abstract class EditBookUseCase {
  Future<ApiResponse<Book>> editBook(Book book, String token);
}
