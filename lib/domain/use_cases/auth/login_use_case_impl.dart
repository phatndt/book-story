import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/entities/jwt_response.dart';

import '../../repository/auth_repo.dart';
import 'login_use_case.dart';

class LoginUseCaseImpl extends LoginUseCase {
  final AuthRepo _authRepo;

  LoginUseCaseImpl(this._authRepo);

  @override
  Future<ApiResponse<JwtResponse>> login(
      String username, String password) async {
    return await _authRepo.login(username, password);
  }
}
