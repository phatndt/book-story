import 'dart:convert';

import 'package:book_exchange/data/entities/post_dto.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/post.dart';
import '../entities/api_response_dto.dart';
import '../entities/user_post_dto.dart';
import 'dio_exception.dart';
import 'dio_service.dart';
import 'end_points.dart';

class PostService {
  Future<ApiResponseDTO<String>> createPost(Post post, String token) async {
    try {
      final body = {
        "content": post.content,
        "createDate": post.createDate,
        "nLikes": post.nLikes,
        "nComments": post.nComments,
        "userId": post.userId,
        "imageUrl": post.imageUrl,
        "bookId": post.bookId,
        "isDeleted": post.isDeleted
      };
      final response = await DioService().dio.post(Endpoints.addPost,
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

  Future<ApiResponseDTO<List<PostDTO>>> getAllPost(token) async {
    try {
      final response = await DioService().dio.get(
            Endpoints.getAllPost,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      var list = response.data['data'] as List;
      return ApiResponseDTO<List<PostDTO>>(
        data: list.map((e) => PostDTO.fromMap(e)).toList(),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<List<UserPostDTO>>> getUserByUserId(
      List<String> userId, String token) async {
    try {
      final body = jsonEncode(userId);
      final response = await DioService().dio.post(
            Endpoints.getUserByUserId,
            data: body,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      var list = response.data['data'] as List;
      return ApiResponseDTO<List<UserPostDTO>>(
        data: list.map((e) => UserPostDTO.fromMap(e)).toList(),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<List<PostDTO>>> getMyPost(token) async {
    try {
      final body = {
        "userId": BookAppModel.user.id,
      };
      final response = await DioService().dio.post(
            Endpoints.getMyPost,
            data: body,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      var list = response.data['data'] as List;
      return ApiResponseDTO<List<PostDTO>>(
        data: list.map((e) => PostDTO.fromMap(e)).toList(),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<String>> deletePost(token, String postId) async {
    try {
      final body = {
        "postId": postId,
      };
      final response = await DioService().dio.post(
            Endpoints.deletePost,
            data: body,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      return ApiResponseDTO<String>(
        data: response.data['data'],
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<PostDTO>> getPostByPostId(token, String postId) async {
    try {
      final body = {
        "postId": postId,
      };
      final response = await DioService().dio.post(
            Endpoints.getPostByPostId,
            data: body,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      return ApiResponseDTO<PostDTO>(
        data: PostDTO.fromMap(response.data['data']),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<String>> updatePost(Post post, String token) async {
    try {
      final body = {
        "id": post.id,
        "content": post.content,
        "createDate": post.createDate,
        "nLikes": post.nLikes,
        "nComments": post.nComments,
        "userId": post.userId,
        "imageUrl": post.imageUrl,
        "bookId": post.bookId,
        "isDeleted": post.isDeleted
      };
      final response = await DioService().dio.post(Endpoints.addPost,
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
}
