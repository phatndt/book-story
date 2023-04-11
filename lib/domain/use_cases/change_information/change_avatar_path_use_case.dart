import '../../entities/api_response.dart';

abstract class ChangeAvatarPathUseCase {
  Future<ApiResponse<String>> changeAvatarPath(
    String avatarPath,
    String token,
    String id,
  );
}
