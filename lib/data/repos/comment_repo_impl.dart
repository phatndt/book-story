import 'package:book_exchange/data/mapper/api_response_mapper.dart';
import 'package:book_exchange/data/services/comment_service.dart';
import 'package:book_exchange/domain/entities/comment.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/repository/comment_repo.dart';

import '../entities/api_response_dto.dart';
import '../entities/comment_dto.dart';

class CommentRepoImpl extends CommentRepo {
  final CommentService _commentService;

  CommentRepoImpl(this._commentService);

  @override
  Future<ApiResponse<String>> createComment(Comment comment, String token) {
    return _commentService.createComment(comment, token).then(
          (value) => value.mapper(),
        );
  }

  @override
  Future<ApiResponse<List<Comment>>> getCommentByPost(
      String postId, String token) {
    return _commentService
        .getCommentByPost(postId, token)
        .then((value) => value.mapper());
  }
}

extension ListComment on ApiResponseDTO<List<CommentDTO>> {
  ApiResponse<List<Comment>> mapper() {
    return ApiResponse(
      data: data.map((e) => e.mapper()).toList(),
      statusCode: statusCode,
      message: message,
    );
  }
}

extension CommentMapper on CommentDTO {
  Comment mapper() {
    return Comment(
      id: id,
      userId: userId,
      postId: postId,
      content: content,
      createDate: createDate,
      isDeleted: isDeleted,
    );
  }
}
