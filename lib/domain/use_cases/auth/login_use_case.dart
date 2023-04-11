import 'package:book_exchange/domain/entities/jwt_response.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
abstract class LoginUseCase {
  Future<ApiResponse<JwtResponse>> login(String username, String password);
}
