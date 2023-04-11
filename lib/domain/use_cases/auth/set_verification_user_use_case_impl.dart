import 'package:book_story/domain/entities/api_response.dart';
import 'package:book_story/domain/repository/auth_repo.dart';
import 'package:book_story/domain/use_cases/auth/set_verification_user_use_case.dart';

class SetVerificationUserUseCaseImpl extends SetVerificationUserUseCase {
  final AuthRepo _authRepo;

  SetVerificationUserUseCaseImpl(this._authRepo);

  @override
  Future<ApiResponse<String>> setVerificationUser(String userId) {
    return _authRepo.setVerificationUser(userId);
  }
}
