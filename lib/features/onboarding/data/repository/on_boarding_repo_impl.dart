import 'package:book_story/features/onboarding/domain/repository/on_boarding_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingRepoImpl extends OnBoardingRepo {
  final SharedPreferences sharedPreferences;

  OnBoardingRepoImpl(this.sharedPreferences);


  @override
  Future<bool?> getIsFirstTimeApp() async {
    return sharedPreferences.getBool("isFirstTime");
  }

  @override
  Future<bool> setIsFirstTimeApp() async {
    return await sharedPreferences.setBool("isFirstTime", false);
  }


}