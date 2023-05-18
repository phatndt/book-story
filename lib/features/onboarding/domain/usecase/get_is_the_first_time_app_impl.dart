import 'package:book_story/features/onboarding/domain/repository/on_boarding_repo.dart';
import 'package:book_story/features/onboarding/domain/usecase/get_is_first_time_app.dart';

class GetIsFirstTimeAppUseCaseImpl extends GetIsFirstTimeAppUseCase {
  final OnBoardingRepo _onBoardingRepo;

  GetIsFirstTimeAppUseCaseImpl(this._onBoardingRepo);

  @override
  Future<bool?> getIsFirstTimeApp() async {
    return await _onBoardingRepo.getIsFirstTimeApp();
  }
}
