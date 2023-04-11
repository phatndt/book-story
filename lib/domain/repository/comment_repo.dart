import '../entities/api_response.dart';
import '../entities/comment.dart';

abstract class CommentRepo {
    Future<ApiResponse<String>> createComment(Comment comment, String token);
    Future<ApiResponse<List<Comment>>> getCommentByPost(String postId, String token);

}