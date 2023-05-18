import 'package:book_story/features/onboarding/domain/usecase/save_is_first_time_app.dart';

import '../repository/on_boarding_repo.dart';

class SaveIsFirstTimeAppUseCaseImpl extends SaveIsFirstTimeAppUseCase {
  final OnBoardingRepo _onBoardingRepo;

  SaveIsFirstTimeAppUseCaseImpl(this._onBoardingRepo);
  @override
  Future<bool> saveIsFirstTime() async {
    return await _onBoardingRepo.setIsFirstTimeApp();
  }
}
