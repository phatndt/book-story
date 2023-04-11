import 'package:dio/dio.dart';

import '../../domain/entities/book_contribution.dart';
import '../entities/api_response_dto.dart';
import '../entities/book_contribution_dto.dart';
import 'dio_exception.dart';
import 'dio_service.dart';
import 'end_points.dart';

class ContributionBookService {
  Future<ApiResponseDTO<ContributionBookDTO>> uploadContributionBook(
      ContributionBook contributionBook, String token) async {
    try {
      final body = {
        "name": contributionBook.name,
        "author": contributionBook.author,
        "description": contributionBook.description,
        "imageUrl": contributionBook.imageUrl,
        "normalBarcode": contributionBook.normalBarcode,
        "isbnBarcode": contributionBook.isbnBarcode,
        "verified": false,
        "deleted": false,
      };
      final response = await DioService().dio.post(
            Endpoints.uploadContributionBook,
            data: body,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
              followRedirects: false,
              // will not throw errors
              validateStatus: (status) => true,
            ),
          );
      return ApiResponseDTO<ContributionBookDTO>(
        data: ContributionBookDTO(
          id: response.data['data'],
          name: 'name',
          author: 'author',
          description: 'description',
          imageUrl: 'imageUrl',
          normalBarcode: 'normalBarcode',
          isbnBarcode: 'isbnBarcode',
          deleted: false,
          verified: false,
        ),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<ContributionBookDTO>>
      getContributionBookByNormalBarcode(
          String normalBarcode, String token) async {
    try {
      final body = {
        "normalBarcode": normalBarcode,
      };

      final response = await DioService().dio.post(
            Endpoints.getContributionBookByNormalBarcode,
            data: body,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      return ApiResponseDTO<ContributionBookDTO>(
        data: ContributionBookDTO.fromMap(response.data['data']),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<ContributionBookDTO>> getContributionBookByISBNBarcode(
      String isbnBarcode, String token) async {
    try {
      final body = {
        "isbnBarcode": isbnBarcode,
      };

      final response = await DioService().dio.post(
            Endpoints.getContributionBookByISBNBarcode,
            data: body,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      return ApiResponseDTO<ContributionBookDTO>(
        data: ContributionBookDTO.fromMap(response.data['data']),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  // Future<ApiResponseDTO<List<ContributionBookDTO>>> getBooksByUserId(
  //     String token) async {
  //   try {
  //     final body = {};
  //     final response = await DioService().dio.post(
  //           Endpoints.getVerifiedContributionBook,
  //           data: body,
  //           options: Options(
  //             headers: {"Authorization": "Bearer $token"},
  //           ),
  //         );
  //     var list = response.data['data'] as List;
  //     List<ContributionBookDTO> T =
  //         list.map((value) => ContributionBookDTO.fromMap(value)).toList();
  //     return ApiResponseDTO<List<ContributionBookDTO>>(
  //       data: T,
  //       statusCode: response.data['statusCode'],
  //       message: response.data['message'],
  //     );
  //   } on DioError catch (e) {
  //     throw DioExceptions.fromDioError(e);
  //   }
  // }
}
