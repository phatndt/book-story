import 'package:book_exchange/domain/entities/api_response.dart';

abstract class VerifyRegistrationUserUseCase {
  Future<ApiResponse<bool>> verifyRegistrationUser(String userId, String code);
}
