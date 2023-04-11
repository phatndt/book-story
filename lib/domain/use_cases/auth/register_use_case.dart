import '../../entities/api_response.dart';

abstract class RegisterUseCase {
  Future<ApiResponse<String>> register(
    String username,
    String password,
    String email,
  );
}
