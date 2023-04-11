import '../../entities/api_response.dart';

abstract class ChangeAdressUseCase {
  Future<ApiResponse<String>> changeAdress(
    String address,
    String token,
    String id,
  );
}
