import 'package:dio/dio.dart';

import '../entities/api_response_dto.dart';
import '../entities/user_dto.dart';
import 'dio_exception.dart';
import 'dio_service.dart';
import 'end_points.dart';

class MapService {
  Future<ApiResponseDTO<List<UserDTO>>> getAllUser(
    String token,
  ) async {
    try {
      final response = await DioService().dio.post(
            Endpoints.getAllUser,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      var list = response.data['data'] as List;
      return ApiResponseDTO<List<UserDTO>>(
        data: list.map((e) => UserDTO.fromMap(e)).toList(),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }
}
