import 'package:book_story/core/presentation/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_module.dart';
import '../../authentication/di/authentication_module.dart';
import '../data/repository/on_boarding_repo_impl.dart';
import '../domain/repository/on_boarding_repo.dart';
import '../domain/usecase/check_logged_use_case.dart';
import '../domain/usecase/check_logged_use_case_impl.dart';
import '../domain/usecase/get_is_first_time_app.dart';
import '../domain/usecase/get_is_the_first_time_app_impl.dart';
import '../domain/usecase/save_is_first_time_app.dart';
import '../domain/usecase/save_is_first_time_app_impl.dart';
import '../presentation/state/splash_state.dart';

final onBoardingRepo = Provider<OnBoardingRepo>((ref) => OnBoardingRepoImpl(ref.watch(sharePreferences)));

final getIsFirstTimeAppUseCase = Provider<GetIsFirstTimeAppUseCase>(
        (ref) => GetIsFirstTimeAppUseCaseImpl(ref.watch(onBoardingRepo)));

final saveIsFirstTimeAppUseCase = Provider<SaveIsFirstTimeAppUseCase>(
        (ref) => SaveIsFirstTimeAppUseCaseImpl(ref.watch(onBoardingRepo)));

final checkLoggedUseCase = Provider<CheckLoggedUseCase>(
        (ref) => CheckLoggedUseCaseImpl(ref.watch(authRepoProvider)));

final splashStateNotifierProvider = StateNotifierProvider<SplashStateNotifier, UIState>((ref) => SplashStateNotifier(
  ref,
  ref.watch(getIsFirstTimeAppUseCase),
  ref.watch(saveIsFirstTimeAppUseCase),
  ref.watch(checkLoggedUseCase),
));