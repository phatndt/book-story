import 'package:book_exchange/data/entities/comment_dto.dart';
import 'package:book_exchange/domain/entities/comment.dart';
import 'package:dio/dio.dart';

import '../entities/api_response_dto.dart';
import 'dio_exception.dart';
import 'dio_service.dart';
import 'end_points.dart';

class CommentService {
  Future<ApiResponseDTO<String>> createComment(
      Comment comment, String token) async {
    try {
      final body = {
        "userId": comment.userId,
        "postId": comment.postId,
        "content": comment.content,
        "createDate": comment.createDate,
        "isDeleted": false
      };
      final response = await DioService().dio.post(Endpoints.createComment,
          data: body,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      return ApiResponseDTO<String>(
        data: response.data['data'],
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<List<CommentDTO>>> getCommentByPost(
      String postId, String token) async {
    try {
      final body = {
        "postId": postId,
      };
      final response = await DioService().dio.post(Endpoints.getCommentByPost,
          data: body,
          options: Options(headers: {"Authorization": "Bearer $token"}));
           var list = response.data['data'] as List;
      return ApiResponseDTO<List<CommentDTO>>(
        data: list.map((e) => CommentDTO.fromMap(e)).toList(),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}
