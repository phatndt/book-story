
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/repository/auth_repo.dart';
import 'package:book_exchange/domain/use_cases/auth/send_email_use_case.dart';

class SendEmailUseCaseImpl extends SendEmailUseCase {
  final AuthRepo _authRepo;

  SendEmailUseCaseImpl(this._authRepo);

  @override
  Future<ApiResponse<String>> sendEmail(String userId) {
    return _authRepo.sendEmail(userId);
  }
}
