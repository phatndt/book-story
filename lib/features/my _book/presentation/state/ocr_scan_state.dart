import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';

class OcrScanStateNotifier extends StateNotifier<UIState> {
  OcrScanStateNotifier(this.ref) : super(UIInitialState());

  final Ref ref;

  getCamera() async {
    try {
      state = const UILoadingState(true);
      final cameras = await availableCameras();
      state = const UILoadingState(false);
      state = UISuccessState(cameras);
    } catch (e) {
      state = UIErrorState(Exception('something_wrong'.tr()));
    }
  }
}
