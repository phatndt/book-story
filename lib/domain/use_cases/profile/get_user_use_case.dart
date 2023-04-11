import 'package:book_exchange/data/services/profile_service.dart';
import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/repository/profile_repo.dart';

import '../../entities/user.dart';

class GetUserUseCase {
  final ProfileRepo _profileRepo;

  GetUserUseCase(this._profileRepo);

  Future<ApiResponse<User>> getUser(String userId, String token) {
    return _profileRepo.getUser(userId, token);
  }
}
