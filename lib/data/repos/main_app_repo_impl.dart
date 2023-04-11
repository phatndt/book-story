import 'package:book_story/data/services/shared_preferences_service.dart';
import 'package:book_story/domain/repository/main_app_repo.dart';

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
