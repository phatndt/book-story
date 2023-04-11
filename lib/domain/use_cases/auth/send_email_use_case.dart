import 'package:book_exchange/domain/entities/api_response.dart';

abstract class SendEmailUseCase {
  Future<ApiResponse<String>> sendEmail(String userId);
}
