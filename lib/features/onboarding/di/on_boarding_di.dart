import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../presentation/di/app_provider.dart' as app;

final splashFutureProviderTest = FutureProvider<bool>((ref) async {
  final getIsFirstTimeAppUseCase = ref.watch(app.getIsFirstTimeAppUseCase);
  final saveIsFirstTimeAppUseCase = ref.watch(app.saveIsFirstTimeAppUseCase);
  bool? isFirstTime = await getIsFirstTimeAppUseCase.getIsFirstTimeApp();
  if (isFirstTime == null || isFirstTime == true) {
    await saveIsFirstTimeAppUseCase.saveIsFirstTime();
    return true;
  }
  return false;
});

final splashProviderTest = Provider<bool>((ref) {
   return ref.watch(splashFutureProviderTest).maybeWhen(data: (data) => data, orElse: () => true);
});

// final splashProviderT = Provider<bool>((ref) {
//   final accountSetupComplete = ref.watch(splashProviderTest).maybeWhen(orElse: orElse)
//
//   return accountSetupComplete;
// });