import '../../entities/api_response.dart';
import '../../entities/book.dart';

abstract class GetListBookUseCase {
  Future<ApiResponse<List<Book>>> getListBook(String token);
}