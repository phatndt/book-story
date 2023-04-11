import 'dart:developer';

import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:book_exchange/presentation/di/change_information.dart';
import 'package:book_exchange/presentation/di/changing_password_component.dart';
import 'package:book_exchange/presentation/di/profile_component.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:book_exchange/presentation/views/widgets/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:location/location.dart';
import '../../../../core/colors/colors.dart';
import '../../../../core/custom_text_form_fill.dart';

class ChangeInformationScreen extends ConsumerWidget {
  const ChangeInformationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: ref
            .watch(changeInformationNotifierProvider)
            .isLoadingChangeInformation,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(S.size.length_50Vertical),
            child: AppBar(
              centerTitle: true,
              title: const Text("Change your information"),
              leading: BackButton(onPressed: () {
                ref.refresh(changeInformationNotifierProvider);
                Navigator.pop(context);
              }),
            ),
          ),
          backgroundColor: S.colors.white,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: S.size.length_20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: S.size.length_20Vertical,
                ),
                Text(
                  'Username',
                  style: S.textStyles.titleText,
                ),
                CustomTextFormField(
                  hintText: BookAppModel.user.username,
                  obscureText: false,
                  controller:
                      ref.watch(changeInformationNotifierProvider).username,
                  suffixIconData: IconButton(
                    onPressed: ref
                        .watch(changeInformationNotifierProvider)
                        .username
                        .clear,
                    icon: const Icon(FontAwesomeIcons.eraser),
                  ),
                  onChanged: (value) {
                    ref
                        .watch(changeInformationNotifierProvider.notifier)
                        .setTextUserName(value);
                  },
                ),
                const Expanded(child: SizedBox()),
                // CustomTextFormField(
                //   hintText: BookAppModel.user.address,
                //   readOnly: true,
                //   onTap: () async {
                //     Location location = Location();

                //     bool _serviceEnabled;
                //     PermissionStatus _permissionGranted;
                //     LocationData _locationData;

                //     _serviceEnabled = await location.serviceEnabled();
                //     if (!_serviceEnabled) {
                //       _serviceEnabled = await location.requestService();
                //       if (!_serviceEnabled) {
                //         return;
                //       }
                //     }

                //     _permissionGranted = await location.hasPermission();
                //     if (_permissionGranted == PermissionStatus.denied) {
                //       _permissionGranted = await location.requestPermission();
                //       if (_permissionGranted != PermissionStatus.granted) {
                //         return;
                //       }
                //     }

                //     _locationData = await location.getLocation();
                //     final lat = _locationData.latitude.toString();
                //     final long = _locationData.longitude.toString();
                //     ref
                //         .watch(changeInformationNotifierProvider)
                //         .address
                //         .text = "$lat|$long";
                //   },
                //   controller:
                //       ref.watch(changeInformationNotifierProvider).address,
                //   obscureText: false,
                //   suffixIconData: IconButton(
                //     onPressed: ref
                //         .watch(changeInformationNotifierProvider)
                //         .address
                //         .clear,
                //     icon: const Icon(FontAwesomeIcons.eraser),
                //   ),
                // ),
                Center(
                  child: CustomFilledButton(
                    width: MediaQuery.of(context).size.width,
                    text: 'CHANGE INFORMATION',
                    onPress: ref.watch(mainAppNotifierProvider).user.username ==
                            ref.watch(changeInformationNotifierProvider).name
                        ? null
                        : () {
                            ref
                                .watch(
                                    changeInformationNotifierProvider.notifier)
                                .changeUsername(context);
                          },
                  ),
                ),
                SizedBox(
                  height: S.size.length_40Vertical,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
