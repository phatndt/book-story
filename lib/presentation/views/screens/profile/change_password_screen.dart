import 'package:book_exchange/core/custom_text_form_fill.dart';
import 'package:book_exchange/presentation/views/widgets/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../core/colors/colors.dart';
import '../../../../core/app_bar.dart';
import '../../../di/changing_password_component.dart';

class ChangePasswordScreen extends ConsumerWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall:
            ref.watch(changingPasswordNotifierProvider).isLoadingProfile,
        child: Scaffold(
          backgroundColor: S.colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(S.size.length_50Vertical),
            child: const AppBarImpl(
              title: 'Change password',
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: S.size.length_20,
                    horizontal: S.size.length_20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Old password',
                        style: S.textStyles.titleText,
                      ),
                      CustomTextFormField(
                        controller: ref
                            .watch(changingPasswordNotifierProvider)
                            .oldPassword,
                        hintText: 'Old password',
                        obscureText: ref
                            .watch(changingPasswordNotifierProvider)
                            .isOldPasswordVisible,
                        suffixIconData: InkWell(
                          onTap: () {
                            ref
                                .watch(
                                    changingPasswordNotifierProvider.notifier)
                                .setOldPasswordVisible();
                          },
                          child: Icon(
                            ref
                                    .watch(changingPasswordNotifierProvider)
                                    .isOldPasswordVisible
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeLowVision,
                            size: 18,
                            color: S.colors.black,
                          ),
                        ),
                      ),
                      Text(
                        'New password',
                        style: S.textStyles.titleText,
                      ),
                      CustomTextFormField(
                        controller: ref
                            .watch(changingPasswordNotifierProvider)
                            .passwordController,
                        hintText: 'New password',
                        obscureText: ref
                            .watch(changingPasswordNotifierProvider)
                            .passwordVisible,
                        suffixIconData: InkWell(
                          onTap: () {
                            ref
                                .watch(
                                    changingPasswordNotifierProvider.notifier)
                                .setPasswordVisible();
                          },
                          child: Icon(
                            ref
                                    .watch(changingPasswordNotifierProvider)
                                    .passwordVisible
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeLowVision,
                            size: 18,
                            color: S.colors.black,
                          ),
                        ),
                      ),
                      Text(
                        'Confirm password',
                        style: S.textStyles.titleText,
                      ),
                      CustomTextFormField(
                        controller: ref
                            .watch(changingPasswordNotifierProvider)
                            .confirmPassword,
                        hintText: 'Confirm password',
                        obscureText: ref
                            .watch(changingPasswordNotifierProvider)
                            .confirmPasswordVisible,
                        suffixIconData: InkWell(
                          onTap: () {
                            ref
                                .watch(
                                    changingPasswordNotifierProvider.notifier)
                                .setConfirmPasswordVisible();
                          },
                          child: Icon(
                            ref
                                    .watch(changingPasswordNotifierProvider)
                                    .confirmPasswordVisible
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeLowVision,
                            size: 18,
                            color: S.colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: S.size.length_40Vertical,
                      ),
                      Center(
                        child: CustomFilledButton(
                          width: MediaQuery.of(context).size.width,
                          text: "Change password",
                          onPress: () {
                            ref
                                .watch(
                                    changingPasswordNotifierProvider.notifier)
                                .changePassword(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
