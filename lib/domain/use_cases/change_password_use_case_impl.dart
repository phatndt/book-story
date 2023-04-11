import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/repository/profile_repo.dart';
import 'package:book_exchange/domain/use_cases/change_pasword_use_case.dart';

class ChangePasswordUseCaseImpl extends ChangePasswordUseCase {
  final ProfileRepo profileRepo;

  ChangePasswordUseCaseImpl(this.profileRepo);
  @override
  Future<ApiResponse<String>> changePassword(
    String username,
    String oldPassword,
    String newPassword,
    String token,
  ) async {
    return await profileRepo.changePassword(
        username, oldPassword, newPassword, token);
  }
}
