import 'package:book_story/domain/entities/api_response.dart';

abstract class SetVerificationUserUseCase {
  Future<ApiResponse<String>> setVerificationUser(String userId);
}
