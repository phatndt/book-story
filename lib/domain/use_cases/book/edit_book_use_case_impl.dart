import 'package:book_exchange/domain/entities/book.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/use_cases/book/edit_book_use_case.dart';

import '../../repository/book_repo.dart';

class EditBookUseCaseImpl extends EditBookUseCase {
  final BookRepo _bookRepo;

  EditBookUseCaseImpl(this._bookRepo);
  @override
  Future<ApiResponse<Book>> editBook(Book book, String token) async {
    return await _bookRepo.editBook(book, token);
  }
}
