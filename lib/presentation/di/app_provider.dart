import 'package:book_exchange/data/repos/main_app_repo_impl.dart';
import 'package:book_exchange/data/services/shared_preferences_service.dart';
import 'package:book_exchange/domain/repository/main_app_repo.dart';
import 'package:book_exchange/domain/use_cases/main/get_is_first_time_app.dart';
import 'package:book_exchange/domain/use_cases/main/get_is_the_first_time_app_impl.dart';
import 'package:book_exchange/domain/use_cases/main/save_is_first_time_app.dart';
import 'package:book_exchange/domain/use_cases/main/save_is_first_time_app_impl.dart';
import 'package:book_exchange/presentation/view_models/splash_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view_models/app_view_model.dart';

final sharedPrefs = FutureProvider<SharedPreferences>(
    (_) async => await SharedPreferences.getInstance());

final sharePreferencesService =
    Provider<SharePreferencesService>((ref) => SharePreferencesService());

final mainAppRepo = Provider<MainAppRepo>(
    (ref) => MainAppRepoImpl(ref.watch(sharePreferencesService)));

final getIsFirstTimeAppUseCase = Provider<GetIsFirstTimeAppUseCase>(
    (ref) => GetIsFirstTimeAppUseCaseImpl(ref.watch(mainAppRepo)));

final saveIsFirstTimeAppUseCase = Provider<SaveIsFirstTimeAppUseCase>(
    (ref) => SaveIsFirstTimeAppUseCaseImpl(ref.watch(mainAppRepo)));

final splashProvider = Provider<SplashProvider>((ref) => SplashProvider(
      ref,
      ref.watch(getIsFirstTimeAppUseCase),
      ref.watch(saveIsFirstTimeAppUseCase),
    ));

final mainAppNotifierProvider =
    StateNotifierProvider<MainAppNotifier, MainApp>(
        ((ref) => MainAppNotifier(ref)));
