import '../../entities/api_response.dart';
import '../../entities/book.dart';

abstract class DeleteBookUseCase {
  Future<ApiResponse<Book>> deleteBook(String bookId, String token);
}
