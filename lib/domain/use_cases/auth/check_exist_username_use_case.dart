


import '../../entities/api_response.dart';

abstract class CheckExistUsernameUseCase {
  Future<ApiResponse<bool>> checkExistEmail(String email);
}