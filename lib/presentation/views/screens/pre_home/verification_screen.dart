import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/colors/colors.dart';
import '../../../di/auth_component.dart';
import '../../widgets/filled_button.dart';
import '../../widgets/outline_button.dart';

class VerificationScreen extends ConsumerWidget {
  const VerificationScreen({Key? key}) : super(key: key);

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
                  "Registration Verification",
                  style: S.textStyles.login.bigTitle,
                ),
                SizedBox(
                  height: S.size.length_10Vertical,
                ),
                Text(
                  "We sent your code to your registered email",
                  style: S.textStyles.login.smallTitle,
                ),
                SizedBox(height: S.size.length_10Vertical),
                SizedBox(
                  height: S.size.length_40Vertical,
                ),
                Center(
                  child: Pinput(
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: S.colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: S.colors.white, width: 1.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onCompleted: (pin) => ref
                        .watch(verificationStateNotifierProvider.notifier)
                        .verifyUser(context, pin),
                  ),
                ),
                SizedBox(
                  height: S.size.length_40Vertical,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomOutlineButton(
                      width: S.size.length_100,
                      text: 'LOGIN',
                      onPress: () {
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                      },
                    ),
                    CustomFilledButton(
                      width: S.size.length_100,
                      text: 'VERIFY',
                      onPress: () {
                        FocusScope.of(context).unfocus();
                        ref
                            .watch(verificationStateNotifierProvider.notifier)
                            .verifyUser(context, ref.watch(verificationStateNotifierProvider).code);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
