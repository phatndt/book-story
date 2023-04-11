import 'dart:io';

import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/presentation/views/widgets/filled_button.dart';
import 'package:book_exchange/presentation/views/widgets/outline_button.dart';
import 'package:book_exchange/presentation/views/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../../core/colors/colors.dart';
import '../../../di/auth_component.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          exit(0);
        },
        child: ModalProgressHUD(
          inAsyncCall: ref.watch(loginSettingNotifierProvider).isLoadingLogin,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: S.size.length_40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: S.size.length_40Vertical,
                    ),
                    Image.asset(
                      'assets/logo/logo_other.png',
                      scale: 1,
                    ),
                    SizedBox(
                      height: S.size.length_40Vertical,
                    ),
                    Text(
                      'WELCOME BACK',
                      style: S.textStyles.login.bigTitle,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: S.size.length_40Vertical,
                    ),
                    CustomTextField(
                      textEditingController: ref
                          .watch(loginSettingNotifierProvider)
                          .emailController,
                      text: 'Email',
                      obscure: false,
                      icon: FontAwesomeIcons.xmark,
                      onClickSuffixIcon: () {
                        ref
                            .watch(loginSettingNotifierProvider.notifier)
                            .cleanEmail();
                      },
                    ),
                    SizedBox(
                      height: S.size.length_20Vertical,
                    ),
                    CustomTextField(
                      textEditingController: ref
                          .watch(loginSettingNotifierProvider)
                          .passwordController,
                      text: 'Password',
                      icon: ref
                              .watch(loginSettingNotifierProvider)
                              .passwordVisible
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeLowVision,
                      obscure: ref
                          .watch(loginSettingNotifierProvider)
                          .passwordVisible,
                      onClickSuffixIcon: () {
                        ref
                            .watch(loginSettingNotifierProvider.notifier)
                            .setPasswordVisible();
                      },
                    ),
                    SizedBox(
                      height: S.size.length_50Vertical,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomOutlineButton(
                          width: S.size.length_100,
                          text: 'SIGN UP',
                          onPress: () {
                            FocusScope.of(context).unfocus();
                            Navigator.pushNamed(context, RoutePaths.signUp);
                          },
                        ),
                        CustomFilledButton(
                          width: S.size.length_100,
                          text: 'LOG IN',
                          onPress: () {
                            FocusScope.of(context).unfocus();
                            ref
                                .watch(loginSettingNotifierProvider.notifier)
                                .login(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: S.size.length_40Vertical,
                    ),
                    GestureDetector(
                      onTap: () {
                        // FocusScope.of(context).unfocus();
                        // Navigator.pushNamed(
                        //   context,
                        //   RoutePaths.forgot,
                        // );
                        Navigator.pushNamed(context, RoutePaths.forgot);
                      },
                      child: Center(
                        child: Text(
                          'Forgot Password?',
                          style: S.textStyles.login.smallTitle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
