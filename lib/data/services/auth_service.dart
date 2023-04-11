import 'package:dio/dio.dart';

import '../entities/api_response_dto.dart';
import '../entities/jwt_response_dto.dart';
import '../entities/user_dto.dart';
import 'dio_exception.dart';
import 'dio_service.dart';
import 'end_points.dart';

class AuthService {
  Future<ApiResponseDTO<JwtResponseDTO>> login(
    String username,
    String password,
  ) async {
    try {
      final body = {
        "username": username,
        "password": password,
      };
      final response = await DioService().dio.post(Endpoints.login, data: body);
      return ApiResponseDTO<JwtResponseDTO>(
        data: JwtResponseDTO.fromMap(response.data['data']),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  Future<ApiResponseDTO<String>> register(
    String username,
    String password,
    String email,
  ) async {
    try {
      final body = {
        "name": username,
        "password": password,
        "email": email,
      };
      final response =
          await DioService().dio.post(Endpoints.register, data: body);
      return ApiResponseDTO<String>(
        data: response.data['data'],
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  Future<ApiResponseDTO<bool>> checkExistEmail(
    String email,
  ) async {
    try {
      final body = {
        "email": email,
      };
      final response = await DioService().dio.post(
            Endpoints.email,
            data: body,
          );
      return ApiResponseDTO<bool>(
        data: response.data['data'],
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  Future<ApiResponseDTO<String>> resetPassword(
    String username,
    String oldPassword,
    String newPassword,
    String token,
  ) async {
    try {
      final body = {
        "username": username,
        "oldPassword": oldPassword,
        "newPassword": newPassword
      };
      final response = await DioService().dio.post(Endpoints.changePassword,
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

  Future<ApiResponseDTO<String>> sendEmail(
    String userId,
  ) async {
    try {
      final body = {
        "userId": userId,
      };
      final response = await DioService()
          .dio
          .post(Endpoints.sendVerificationEmailWhenRegistering, data: body);
      return ApiResponseDTO<String>(
        data: response.data['data'],
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  Future<ApiResponseDTO<bool>> verifyUser(
    String userId,
    String code,
  ) async {
    try {
      final body = {
        "userId": userId,
        "code": code,
      };
      final response = await DioService()
          .dio
          .post(Endpoints.verifyRegistrationUser, data: body);
      return ApiResponseDTO<bool>(
        data: response.data['data'],
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  Future<ApiResponseDTO<String>> setVerificationUser(
    String userId,
  ) async {
    try {
      final body = {
        "userId": userId,
      };
      final response = await DioService()
          .dio
          .post(Endpoints.setVerificationUser, data: body);
      return ApiResponseDTO<String>(
        data: response.data['data'],
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }
}
