import '../../entities/api_response.dart';
import '../../entities/post.dart';

abstract class GetMyPostUseCase {
  Future<ApiResponse<List<Post>>> getMyPost(String token);
}
