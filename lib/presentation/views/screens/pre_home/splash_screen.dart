import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(splashProvider).init(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Image.asset('assets/logo/logo.png'),
        ),
      ),
    );
  }
}
