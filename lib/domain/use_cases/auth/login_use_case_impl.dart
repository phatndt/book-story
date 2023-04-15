import 'package:book_story/domain/entities/api_response.dart';
import 'package:book_story/domain/entities/jwt_response.dart';

import '../../../features/authentication/domain/repository/auth_repo.dart';
import '../../entities/user.dart';
import 'login_use_case.dart';

class LoginUseCaseImpl extends LoginUseCase {
  final AuthRepo _authRepo;

  LoginUseCaseImpl(this._authRepo);

  @override
  Future<ApiResponse<JwtResponse>> login(
      String username, String password) async {
    return Future.value(ApiResponse<JwtResponse>(
      data: JwtResponse(token: "",user: User("","", "", "", "", "",true, true)),
      statusCode:200,
      message: "",
    ));
  }
}
