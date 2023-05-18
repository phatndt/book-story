import 'package:book_story/features/onboarding/presentation/state/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/navigation/route_paths.dart';
import '../di/on_boarding_module.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.watch(splashStateNotifierProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashStateNotifierProvider, (previous, next) {
      if (next is UIFirstTimeState) {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutePaths.welcome, (route) => false);
      } else if (next is UILoggedState) {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutePaths.main, (route) => false);
      } else if (next is UINotLoggedState) {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutePaths.logIn, (route) => false);
      }
    });
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Image.asset('assets/logo/logo.png'),
        ),
      ),
    );
  }
}
