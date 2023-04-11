import 'package:book_exchange/data/entities/user_dto.dart';
import 'package:book_exchange/data/services/map_service.dart';
import 'package:book_exchange/domain/entities/api_response.dart';

import '../../domain/entities/user.dart';
import '../entities/api_response_dto.dart';

class MapRepoImpl {
  final MapService _mapService;

  MapRepoImpl(this._mapService);

  Future<ApiResponse<List<User>>> getAllUser(String token) {
    return _mapService.getAllUser(token).then((value) => value.mapper());
  }
}

extension ApiResponseListUserDTO on ApiResponseDTO<List<UserDTO>> {
  ApiResponse<List<User>> mapper() {
    return ApiResponse(
      data: data.map((e) => e.mapper()).toList(),
      statusCode: statusCode,
      message: message,
    );
  }
}

extension UserDTOMapper on UserDTO {
  User mapper() {
    return User(
      id,
      name,
      password,
      email,
      address,
      image,
      isVerified,
      isDeleted,
    );
  }
}
