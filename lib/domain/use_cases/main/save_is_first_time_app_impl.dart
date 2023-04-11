import 'package:book_exchange/domain/use_cases/main/save_is_first_time_app.dart';

import '../../repository/main_app_repo.dart';

class SaveIsFirstTimeAppUseCaseImpl extends SaveIsFirstTimeAppUseCase {
  final MainAppRepo _mainAppRepo;

  SaveIsFirstTimeAppUseCaseImpl(this._mainAppRepo);
  @override
  Future<bool> saveIsFirstTime() async {
    return await _mainAppRepo.setIsFirstTimeApp();
  }
}
