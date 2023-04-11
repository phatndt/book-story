import 'package:book_story/domain/entities/api_response.dart';

import '../../entities/post.dart';

abstract class GetPostByPostIdUseCase {
  Future<ApiResponse<Post>> getPostByPostId(String token, String postId);
}