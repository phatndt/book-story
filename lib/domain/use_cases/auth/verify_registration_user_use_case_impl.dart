import 'package:book_story/domain/entities/api_response.dart';
import 'package:book_story/domain/repository/auth_repo.dart';
import 'package:book_story/domain/use_cases/auth/verify_registration_user_use_case.dart';

class VerifyRegistrationUserUseCaseImpl extends VerifyRegistrationUserUseCase {
  final AuthRepo _authRepo;

  VerifyRegistrationUserUseCaseImpl(this._authRepo);

  @override
  Future<ApiResponse<bool>> verifyRegistrationUser(String userId, String code) {
    return _authRepo.verifyRegistrationUser(userId, code);
  }
}
