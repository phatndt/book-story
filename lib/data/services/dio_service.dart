import 'package:book_exchange/data/services/end_points.dart';
import 'package:dio/dio.dart';

class DioService {
  static final DioService _instance = DioService._internal(
    Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: Endpoints.connectionTimeout,
        receiveTimeout: Endpoints.receiveTimeout,
        responseType: ResponseType.json,
      ),
    ),
  );
  late Dio _dio;

  Dio get dio => _dio;

  factory DioService() {
    return _instance;
  }

  DioService._internal(Dio dio) {
    _dio = dio;
  }
}
