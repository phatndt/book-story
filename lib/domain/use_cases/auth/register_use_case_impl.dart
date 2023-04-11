import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/repository/auth_repo.dart';

import 'register_use_case.dart';

class RegisterUseCaseImpl extends RegisterUseCase {
  final AuthRepo _authRepo;

  RegisterUseCaseImpl(this._authRepo);

  @override
  Future<ApiResponse<String>> register(
    String username,
    String password,
    String email,
  ) async {
    return await _authRepo.register(username, password, email);
  }
}
