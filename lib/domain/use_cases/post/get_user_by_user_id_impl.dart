import 'package:book_story/domain/entities/api_response.dart';
import 'package:book_story/domain/repository/post_repo.dart';
import 'package:book_story/domain/use_cases/post/get_user_by_user_id.dart';

import '../../entities/user_post.dart';

class GetUserByUserIdImpl extends GetUserByUserId {
  final PostRepo _postRepo;

  GetUserByUserIdImpl(this._postRepo);

  @override
  Future<ApiResponse<List<UserPost>>> getUserByUserId(
      List<String> userId, String token) {
    return _postRepo.getUserByUserId(userId, token);
  }
}
