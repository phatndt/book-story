import 'package:book_exchange/data/services/shared_preferences_service.dart';
import 'package:book_exchange/domain/repository/main_app_repo.dart';

class MainAppRepoImpl extends MainAppRepo {
  final SharePreferencesService _sharePreferencesService;

  MainAppRepoImpl(this._sharePreferencesService);

  @override
  Future<bool?> getIsFirstTimeApp() async {
    return await _sharePreferencesService.getIsFirstTimeApp();
  }

  @override
  Future<bool> setIsFirstTimeApp() async {
    return await _sharePreferencesService.setIsFirstTimeApp();
  }
}
