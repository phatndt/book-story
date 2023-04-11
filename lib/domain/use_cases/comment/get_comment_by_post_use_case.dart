import '../../entities/api_response.dart';
import '../../entities/comment.dart';
import '../../repository/comment_repo.dart';

class GetCommentByPostUseCase {
  final CommentRepo _commentRepo;

  GetCommentByPostUseCase(this._commentRepo);

  Future<ApiResponse<List<Comment>>> getCommentByPost(String postId, String token) {
    return _commentRepo.getCommentByPost(postId, token);
  }
}
