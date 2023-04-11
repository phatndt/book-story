import 'package:book_story/domain/entities/api_response.dart';

import '../../entities/post.dart';

abstract class AddPostUseCase {
  Future<ApiResponse<String>> createPost(Post post, String token);
}
