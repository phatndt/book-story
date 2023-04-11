import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PreHomeSetting {
  //FORGOT PASSWORD
  final TextEditingController fpEmailController;

  bool isLoadingLogin = false;

  PreHomeSetting({
    required this.fpEmailController,
    this.isLoadingLogin = false,
  });

  PreHomeSetting copy({
    TextEditingController? fpEmailController,
    bool? isLoadingLogin,
  }) =>
      PreHomeSetting(
        fpEmailController: fpEmailController ?? this.fpEmailController,
        isLoadingLogin: isLoadingLogin ?? this.isLoadingLogin,
      );

}

class PreHomeSettingNotifier extends StateNotifier<PreHomeSetting> {
  PreHomeSettingNotifier(this.ref)
      : super(
          PreHomeSetting(
            fpEmailController: TextEditingController(),
          ),
        );

  final Ref ref;
}

final preHomeSettingNotifierProvider =
    StateNotifierProvider<PreHomeSettingNotifier, PreHomeSetting>(
        ((ref) => PreHomeSettingNotifier(ref)));
