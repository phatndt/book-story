import 'package:book_story/domain/entities/post.dart';

import '../../entities/api_response.dart';

abstract class GetAllPostUseCase {
  Future<ApiResponse<List<Post>>> getAllPost(String token);
}
