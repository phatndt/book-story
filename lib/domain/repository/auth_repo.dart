import '../entities/api_response.dart';
import '../entities/jwt_response.dart';

abstract class AuthRepo {
  Future<ApiResponse<JwtResponse>> login(
    String username,
    String password,
  );

  Future<ApiResponse<String>> register(
    String username,
    String password,
    String email,
  );

  Future<ApiResponse<bool>> checkExistEmail(
    String email,
  );

  Future<ApiResponse<String>> resetPassword(
    String username,
    String oldPassword,
    String newPassword,
    String token,
  );

  Future<ApiResponse<String>> sendEmail(
    String userId,
  );

  Future<ApiResponse<bool>> verifyRegistrationUser(
    String userId,
    String code,
  );
  Future<ApiResponse<String>> setVerificationUser(
    String userId,
  );
}
