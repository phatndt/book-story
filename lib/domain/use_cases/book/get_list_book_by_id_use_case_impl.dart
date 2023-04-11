import 'package:book_story/domain/entities/book.dart';
import 'package:book_story/domain/entities/api_response.dart';
import 'package:book_story/domain/repository/book_repo.dart';
import 'package:book_story/domain/use_cases/book/get_list_book_by_id_use_case.dart';

class GetListBookByIdUseCaseImpl extends GetListBookUseCase {
  final BookRepo _bookRepo;

  GetListBookByIdUseCaseImpl(this._bookRepo);

  @override
  Future<ApiResponse<List<Book>>> getListBook(String token) async {
    return await _bookRepo.getBooksByUserId(token);
  }
}
