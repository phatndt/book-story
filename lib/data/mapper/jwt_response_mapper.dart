import 'package:book_exchange/data/entities/jwt_response_dto.dart';
import 'package:book_exchange/data/mapper/user_mapper.dart';
import 'package:book_exchange/domain/entities/jwt_response.dart';

import '../base/base_mapper.dart';

class JwtResponseMapper extends BaseMapper<JwtResponseDTO, JwtResponse> {
  @override
  JwtResponse transfer(JwtResponseDTO d) {
    return JwtResponse(token: d.token, user: UserMapper().transfer(d.user));
  }
}
