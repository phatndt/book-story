import 'package:book_exchange/presentation/view_models/pre_home_viewmodel.dart';
import 'package:book_exchange/presentation/views/widgets/filled_button.dart';
import 'package:book_exchange/presentation/views/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/colors/colors.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
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
                  'RESET YOUR PASSWORD',
                  style: S.textStyles.login.bigTitle,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: S.size.length_40Vertical,
                ),
                Text(
                  'Let we send you a email to \nreset password',
                  style: S.textStyles.login.smallTitle,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: S.size.length_40Vertical,
                ),
                CustomTextField(
                  textEditingController: ref
                      .watch(preHomeSettingNotifierProvider)
                      .fpEmailController,
                  text: 'Email',
                  obscure: false,
                ),
                SizedBox(
                  height: S.size.length_50Vertical,
                ),
                CustomFilledButton(
                  width: S.size.length_130,
                  text: 'CONFIRM',
                  onPress: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
