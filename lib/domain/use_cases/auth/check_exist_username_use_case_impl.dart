
import 'package:book_exchange/domain/repository/auth_repo.dart';

import '../../entities/api_response.dart';
import 'check_exist_username_use_case.dart';

class CheckExistUsernameUseCaseImpl extends CheckExistUsernameUseCase {
  final AuthRepo _authRepo;

  CheckExistUsernameUseCaseImpl(this._authRepo);

  @override
  Future<ApiResponse<bool>> checkExistEmail(String email) async {
    return await _authRepo.checkExistEmail(email);
  }
}
