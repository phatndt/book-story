import 'package:book_exchange/domain/use_cases/post/update_post_use_case.dart';

import '../../entities/api_response.dart';
import '../../entities/post.dart';
import '../../repository/post_repo.dart';

class UpdatePostUseCaseImpl extends UpdatePostUseCase {
  final PostRepo _postRepo;

  UpdatePostUseCaseImpl(this._postRepo);

  @override
  Future<ApiResponse<String>> updatePost(Post post, String token) {
    return _postRepo.updatePost(post, token);
  }
}
