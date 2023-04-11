import '../../entities/api_response.dart';
import '../../repository/profile_repo.dart';
import 'change_avatar_path_use_case.dart';

class ChangeAvatarPathUseCaseImpl extends ChangeAvatarPathUseCase {
  final ProfileRepo profileRepo;

  ChangeAvatarPathUseCaseImpl(this.profileRepo);
  @override
  Future<ApiResponse<String>> changeAvatarPath(
      String avatarPath, String token, String id) {
    return profileRepo.changeAvatarPath(avatarPath, token, id);
  }
}
