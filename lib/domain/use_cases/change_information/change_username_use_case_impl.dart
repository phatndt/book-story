import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/use_cases/change_information/change_username_use_case.dart';

import '../../repository/profile_repo.dart';

class ChangeUsernameUseCaseImpl extends ChangeUsernameUseCase {
  final ProfileRepo profileRepo;

  ChangeUsernameUseCaseImpl(this.profileRepo);
  @override
  Future<ApiResponse<String>> changeUsername(
      String username, String token, String id) async {
    return await profileRepo.changeUsername(username, token, id);
  }
}
