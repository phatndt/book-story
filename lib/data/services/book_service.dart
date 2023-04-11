import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dospace/dospace.dart' as dospace;

import '../../core/core.dart';
import '../../domain/entities/book.dart';
import '../entities/api_response_dto.dart';
import '../entities/book_dto.dart';
import 'dio_exception.dart';
import 'dio_service.dart';
import 'end_points.dart';

class BookService {
  // Future<CloudinaryResponse> uploadImageToCloudinary(
  //   String imagePath,
  //   Future<Uint8List> fileBytes,
  //   String imageName,
  // ) async {
  //   final cloudinary = Cloudinary.full(
  //     apiKey: '735947945251852',
  //     apiSecret: 'O-Rd18L74ukuNN91I8vrzBJXeGI',
  //     cloudName: 'du7lkcbqm',
  //   );

  //   return await cloudinary
  //       .uploadResource(CloudinaryUploadResource(
  //           filePath: imagePath,
  //           fileBytes: await fileBytes,
  //           resourceType: CloudinaryResourceType.image,
  //           folder: 'adu',
  //           fileName: imageName,
  //           progressCallback: (count, total) {
  //             log('Uploading image from file with progress: $count/$total');
  //           }))
  //       .catchError(
  //     (onError) {
  //       throw onError;
  //     },
  //   );
  // }

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

  Future<ApiResponseDTO<BookDTO>> uploadBook(Book book, String token) async {
    try {
      final body = {
        "name": book.name,
        "author": book.author,
        "description": book.description,
        "rate": book.rate,
        "imageUrl": book.imageURL,
        "userId": book.userId
      };

      final response = await DioService().dio.post(
            Endpoints.uploadBook,
            data: body,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      return ApiResponseDTO<BookDTO>(
        data: BookDTO.fromMap(response.data['data']),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<BookDTO>> editBook(Book book, String token) async {
    try {
      final body = {
        "id": book.id,
        "name": book.name,
        "author": book.author,
        "description": book.description,
        "rate": book.rate,
        "imageUrl": book.imageURL,
        "userId": book.userId,
        "delete": book.delete
      };

      final response = await DioService().dio.post(
            Endpoints.editBook,
            data: body,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      return ApiResponseDTO<BookDTO>(
        data: BookDTO.fromMap(response.data['data']),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<BookDTO>> deleteBook(
      String bookId, String token) async {
    try {
      final body = {"bookId": bookId};
      final response = await DioService().dio.post(
            Endpoints.deleteBook,
            data: body,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      log(body.toString());
      return ApiResponseDTO<BookDTO>(
        data: BookDTO.fromMap(response.data['data']),
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<ApiResponseDTO<List<BookDTO>>> getBooksByUserId(String token) async {
    try {
      final body = {"userId": getUserIdFromToken(token)};
      final response = await DioService().dio.post(
            Endpoints.getBookByUserId,
            data: body,
            options: Options(
              headers: {"Authorization": "Bearer $token"},
            ),
          );
      var list = response.data['data'] as List;
      List<BookDTO> T = list.map((value) => BookDTO.fromMap(value)).toList();
      return ApiResponseDTO<List<BookDTO>>(
        data: T,
        statusCode: response.data['statusCode'],
        message: response.data['message'],
      );
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}
