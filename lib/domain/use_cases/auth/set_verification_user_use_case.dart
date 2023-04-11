import 'package:book_exchange/domain/entities/api_response.dart';

abstract class SetVerificationUserUseCase {
  Future<ApiResponse<String>> setVerificationUser(String userId);
}
