import 'package:book_story/data/repos/map_repo_impl.dart';
import 'package:book_story/domain/entities/api_response.dart';

import '../../entities/user.dart';

class GetAllUserUserCase {
  final MapRepoImpl _mapRepoImpl;

  GetAllUserUserCase(this._mapRepoImpl);

  Future<ApiResponse<List<User>>> getAllUser(String token) {
    return _mapRepoImpl.getAllUser(token);
  }
}
