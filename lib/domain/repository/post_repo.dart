import '../entities/api_response.dart';
import '../entities/post.dart';
import '../entities/user_post.dart';

abstract class PostRepo {
  Future<ApiResponse<String>> createPost(Post post, String token);
  Future<ApiResponse<List<Post>>> getAllPost(String token);
  Future<ApiResponse<List<UserPost>>> getUserByUserId(
      List<String> userId, String token);
  Future<ApiResponse<List<Post>>> getMyPost(String token);
  Future<ApiResponse<String>> deletePost(String token, String postId);
  Future<ApiResponse<Post>> getPostByPostId(token, String postId);
  Future<ApiResponse<String>> updatePost(Post post, String token);
}
