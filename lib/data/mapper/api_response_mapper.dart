import 'dart:core';

import 'package:book_exchange/data/base/base_mapper.dart';
import 'package:book_exchange/data/entities/api_response_dto.dart';
import 'package:book_exchange/data/entities/jwt_response_dto.dart';
import 'package:book_exchange/data/entities/post_dto.dart';
import 'package:book_exchange/data/mapper/jwt_response_mapper.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/entities/jwt_response.dart';

import '../../domain/entities/post.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_post.dart';
import '../entities/user_post_dto.dart';

class ApiJwtResponseMapper extends BaseMapper<ApiResponseDTO<JwtResponseDTO>,
    ApiResponse<JwtResponse>> {
  @override
  ApiResponse<JwtResponse> transfer(ApiResponseDTO<JwtResponseDTO> d) {
    return ApiResponse(
      data: JwtResponseMapper().transfer(d.data),
      statusCode: d.statusCode,
      message: d.message,
    );
  }
}

class ApiStringResponseMapper
    extends BaseMapper<ApiResponseDTO<String>, ApiResponse<String>> {
  @override
  ApiResponse<String> transfer(ApiResponseDTO<String> d) {
    return ApiResponse(
      data: d.data,
      statusCode: d.statusCode,
      message: d.message,
    );
  }
}

class ApiBoolResponseMapper
    extends BaseMapper<ApiResponseDTO<bool>, ApiResponse<bool>> {
  @override
  ApiResponse<bool> transfer(ApiResponseDTO<bool> d) {
    return ApiResponse(
      data: d.data,
      statusCode: d.statusCode,
      message: d.message,
    );
  }
}

extension Ext on ApiResponseDTO<String> {
  ApiResponse<String> mapper() {
    return ApiResponse(
      data: data,
      statusCode: statusCode,
      message: message,
    );
  }
}

extension MapperBool on ApiResponseDTO<bool> {
  ApiResponse<bool> mapper() {
    return ApiResponse(
      data: data,
      statusCode: statusCode,
      message: message,
    );
  }
}

extension PostMapper on PostDTO {
  Post mapper() {
    return Post(
      id: id,
      content: content,
      createDate: createDate,
      nLikes: nLikes,
      nComments: nComments,
      userId: userId,
      imageUrl: imageUrl,
      bookId: bookId,
      isDeleted: isDeleted,
    );
  }
}

extension ListPost on ApiResponseDTO<List<PostDTO>> {
  ApiResponse<List<Post>> mapper() {
    return ApiResponse(
      data: data.map((e) => e.mapper()).toList(),
      statusCode: statusCode,
      message: message,
    );
  }
}

extension ApiResponsePost on ApiResponseDTO<PostDTO> {
  ApiResponse<Post> mapperPost() {
    return ApiResponse(
      data: data.mapper(),
      statusCode: statusCode,
      message: message,
    );
  }
}

extension ExtUserPost on UserPostDTO {
  UserPost mapperUserPost() {
    return UserPost(
      imageUrl: imageUrl,
      username: username,
      userId: userId,
    );
  }
}

extension MapPostByUser on ApiResponseDTO<List<UserPostDTO>> {
  ApiResponse<List<UserPost>> mapperPostByUser() {
    return ApiResponse(
      data: data.map((e) => e.mapperUserPost()).toList(),
      statusCode: statusCode,
      message: message,
    );
  }
}

extension MapToUser on ApiResponseDTO<User> {
  ApiResponse<User> mapToUser() {
    return ApiResponse(
      data: data,
      statusCode: statusCode,
      message: message,
    );
  }
}