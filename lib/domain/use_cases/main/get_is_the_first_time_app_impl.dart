import 'package:book_exchange/domain/repository/main_app_repo.dart';
import 'package:book_exchange/domain/use_cases/main/get_is_first_time_app.dart';

class GetIsFirstTimeAppUseCaseImpl extends GetIsFirstTimeAppUseCase {
  final MainAppRepo _mainAppRepo;

  GetIsFirstTimeAppUseCaseImpl(this._mainAppRepo);

  @override
  Future<bool?> getIsFirstTimeApp() async {
    return await _mainAppRepo.getIsFirstTimeApp();
  }
}
