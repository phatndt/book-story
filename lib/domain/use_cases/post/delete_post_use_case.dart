import 'package:book_story/domain/entities/api_response.dart';

abstract class DeletePostUseCase {
  Future<ApiResponse<String>> deletePost(String token, String postId);
}
