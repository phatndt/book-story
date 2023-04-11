import '../../entities/api_response.dart';
import '../../entities/post.dart';

abstract class UpdatePostUseCase {
  Future<ApiResponse<String>> updatePost(Post post, String token);
}
