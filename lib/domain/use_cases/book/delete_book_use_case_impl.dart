import 'package:book_exchange/domain/entities/book.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/use_cases/book/delete_book_use_case.dart';

import '../../repository/book_repo.dart';

class DeleteBookUseCaseImpl extends DeleteBookUseCase {
  final BookRepo _bookRepo;

  DeleteBookUseCaseImpl(this._bookRepo);
  @override
  Future<ApiResponse<Book>> deleteBook(String bookId, String token) async {
    return await _bookRepo.deleteBook(bookId, token);
  }
}
