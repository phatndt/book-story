import 'package:book_story/domain/entities/jwt_response.dart';
import 'package:book_story/domain/entities/api_response.dart';
abstract class LoginUseCase {
  Future<ApiResponse<JwtResponse>> login(String username, String password);
}
