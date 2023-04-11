import 'package:book_exchange/data/mapper/api_response_mapper.dart';
import 'package:book_exchange/data/services/post_service.dart';
import 'package:book_exchange/domain/entities/post.dart';
import 'package:book_exchange/domain/repository/post_repo.dart';

import '../../domain/entities/api_response.dart';
import '../../domain/entities/user_post.dart';

class PostRepoImpl extends PostRepo {
  final PostService _postService;

  PostRepoImpl(this._postService);

  @override
  Future<ApiResponse<String>> createPost(Post post, String token) {
    return _postService.createPost(post, token).then((value) => value.mapper());
  }

  @override
  Future<ApiResponse<List<Post>>> getAllPost(String token) {
    return _postService.getAllPost(token).then((value) => value.mapper());
  }

  @override
  Future<ApiResponse<List<UserPost>>> getUserByUserId(
      List<String> userId, String token) {
    return _postService
        .getUserByUserId(userId, token)
        .then((value) => value.mapperPostByUser());
  }

  @override
  Future<ApiResponse<List<Post>>> getMyPost(String token) {
    return _postService.getMyPost(token).then((value) => value.mapper());
  }

  @override
  Future<ApiResponse<String>> deletePost(String token, String postId) {
    return _postService
        .deletePost(token, postId)
        .then((value) => value.mapper());
  }

  @override
  Future<ApiResponse<Post>> getPostByPostId(token, String postId) {
    return _postService
        .getPostByPostId(token, postId)
        .then((value) => value.mapperPost());
  }

  @override
  Future<ApiResponse<String>> updatePost(Post post, String token) {
    return _postService.updatePost(post, token).then((value) => value.mapper());
  }
}
