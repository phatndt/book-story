import 'package:book_exchange/domain/entities/book.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/use_cases/book/upload_book_use_case.dart';

import '../../repository/book_repo.dart';

class UploadBookUseCaseImpl extends UploadBookUseCase {
  final BookRepo _bookRepo;

  UploadBookUseCaseImpl(this._bookRepo);

  @override
  Future<ApiResponse<Book>> uploadBook(Book book, String token) async {
    return await _bookRepo.uploadBook(book, token);
  }
}
