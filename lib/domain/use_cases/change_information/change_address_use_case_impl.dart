import 'package:book_exchange/domain/entities/api_response.dart';

import '../../repository/profile_repo.dart';
import 'change_address_use_case.dart';

class ChangeAdressUseCaseImpl extends ChangeAdressUseCase {
  final ProfileRepo profileRepo;

  ChangeAdressUseCaseImpl(this.profileRepo);
  @override
  Future<ApiResponse<String>> changeAdress(String address, String token, String id) async {
    return await profileRepo.changeAddress(address, token, id);
  }
}
