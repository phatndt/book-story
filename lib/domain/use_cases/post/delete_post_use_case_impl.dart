import 'package:book_story/domain/entities/api_response.dart';
import 'package:book_story/domain/repository/post_repo.dart';
import 'package:book_story/domain/use_cases/post/delete_post_use_case.dart';

class DeletePostUseCaseImpl extends DeletePostUseCase {
  final PostRepo _postRepo;

  DeletePostUseCaseImpl(this._postRepo);

  @override
  Future<ApiResponse<String>> deletePost(String token, String postId) {
    return _postRepo.deletePost(token, postId);
  }
}
