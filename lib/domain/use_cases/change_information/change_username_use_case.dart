import '../../entities/api_response.dart';

abstract class ChangeUsernameUseCase {
  Future<ApiResponse<String>> changeUsername(
    String username,
    String token,
    String id,
  );
}
