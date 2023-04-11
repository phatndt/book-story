import 'package:book_exchange/domain/repository/comment_repo.dart';

import '../../entities/api_response.dart';
import '../../entities/comment.dart';

class CreateCommentUseCase {
  final CommentRepo _commentRepo;

  CreateCommentUseCase(this._commentRepo);

  Future<ApiResponse<String>> createPost(Comment comment, String token) {
    return _commentRepo.createComment(comment, token);
  }
}
