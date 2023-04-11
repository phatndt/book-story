import 'dart:developer';
import 'dart:io';

import 'package:book_exchange/data/entities/user_dto.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';
import '../entities/api_response_dto.dart';
import '../mapper/user_mapper.dart';
import 'dio_exception.dart';
import 'dio_service.dart';
import 'end_points.dart';
import 'package:dospace/dospace.dart' as dospace;

class ProfileService {
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

  Future<ApiResponseDTO<String>> changeAddress(
    String address,
    String token,
    String id,
  ) async {
    try {
      final body = {
        "userId": id,
        "address": address,
      };
      final response = await DioService().dio.post(Endpoints.changeAdress,
          data: body,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      log(body.toString());
      return ApiResponseDTO<String>(
        data: response.data['data'],
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<String>> changeUsername(
    String username,
    String token,
    String id,
  ) async {
    try {
      final body = {
        "userId": id,
        "username": username,
      };
      final response = await DioService().dio.post(Endpoints.changeUsername,
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

  Future<ApiResponseDTO<String>> changeAvatarPath(
    String avatarPath,
    String token,
    String id,
  ) async {
    try {
      final body = {
        "userId": id,
        "image": avatarPath,
      };
      final response = await DioService().dio.post(
            Endpoints.changeAvatarPath,
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

  Future<String?> uploadImageToSpaces(
    String path,
    File file,
  ) async {
    dospace.Spaces spaces = dospace.Spaces(
      region: "sgp1",
      accessKey: "DO004KQQ9Z2KPTGV29R9",
      secretKey: "BDIpJ4kDXGpkZ1kEcBr5SNlcNwM1Wc0+TfrgCnw+9zo",
    );
    //change with your project's name
    String projectName = "da2";
    //change with your project's folder
    String folderName = path;
    String fileName = file.path.split('/').last;

    String? etag = await spaces.bucket(projectName).uploadFile(
          folderName + "/" + fileName,
          file,
          'image/png',
          dospace.Permissions.public,
        );
    log('upload: $etag');
    if (etag != null) {
      await spaces.close();
      return "https://da2.sgp1.digitaloceanspaces.com/" +
          folderName +
          "/" +
          fileName;
    }
    return null;
  }

  Future<ApiResponseDTO<User>> getUser(
    String userId,
    String token,
  ) async {
    try {
      final body = {
        "userId": userId,
      };
      final response = await DioService().dio.post(
            Endpoints.getUser,
            data: body,
            options: Options(headers: {"Authorization": "Bearer $token"}),
          );
      return ApiResponseDTO<User>(
        data: UserMapper().transfer(UserDTO.fromMap(response.data['data'])),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}
