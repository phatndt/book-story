import 'package:book_exchange/domain/entities/book_contribution.dart';
import 'package:book_exchange/presentation/di/book_contribution_component.dart';
import 'package:book_exchange/presentation/views/widgets/filled_button.dart';
import 'package:book_exchange/presentation/views/widgets/filled_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../core/colors/colors.dart';
import '../../../../../core/custom_text_form_fill.dart';

class AddContributionBookScreen extends ConsumerWidget {
  const AddContributionBookScreen(
      {required this.bookName,
      required this.bookAuthor,
      required this.bookDescription,
      required this.imageUrl,
      Key? key})
      : super(key: key);

  final String bookName;
  final String bookAuthor;
  final String bookDescription;
  final String imageUrl;

  // final bool isDelete;
  // final bool isVerified;
  // final String normalBarcode;
  // final String isbnBarcode;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: ref
            .watch(addContributionBookSettingNotifierProvider)
            .isLoadingContributionBook,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(S.size.length_50Vertical),
            child: AppBar(
              centerTitle: true,
              title: const Text("Contribute this book"),
              leading: BackButton(onPressed: () {
                ref
                    .watch(addContributionBookSettingNotifierProvider.notifier)
                    .clearInput();
                Navigator.pop(context);
              }),
              // actions: [
              //   Padding(
              //     padding: EdgeInsets.symmetric(
              //       horizontal: S.size.length_8,
              //     ),
              //     child: IconButton(
              //       icon: const Icon(
              //         FontAwesomeIcons.barcode,
              //       ),
              //       onPressed: () {
              //         // ref
              //         //     .watch(addContributionBookSettingNotifierProvider
              //         //         .notifier)
              //         //     .scanBarcodeNormal();
              //       },
              //     ),
              //   ),
              // ],
            ),
          ),
          backgroundColor: S.colors.white,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: S.size.length_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: S.size.length_20Vertical,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Normal Barcode',
                        style: S.textStyles.titleText,
                      ),
                      CustomFilledIconButton(
                        iconData: FontAwesomeIcons.barcode,
                        width: S.size.length_40,
                        height: S.size.length_40Vertical,
                        size: S.size.length_20,
                        onPress: () {
                          ref
                              .watch(addContributionBookSettingNotifierProvider
                                  .notifier)
                              .scanNormalBarcode(context);
                        },
                      ),
                    ],
                  ),
                  CustomTextFormField(
                    controller: ref
                        .watch(addContributionBookSettingNotifierProvider)
                        .normalBarcode,
                    suffixIconData: IconButton(
                      onPressed: ref
                          .watch(addContributionBookSettingNotifierProvider)
                          .normalBarcode
                          .clear,
                      icon: const Icon(FontAwesomeIcons.eraser),
                    ),
                    obscureText: false,
                    maxLength: 13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ISBN Barcode',
                        style: S.textStyles.titleText,
                      ),
                      CustomFilledIconButton(
                        iconData: FontAwesomeIcons.barcode,
                        width: S.size.length_40,
                        height: S.size.length_40Vertical,
                        size: S.size.length_20,
                        onPress: () {
                          ref
                              .watch(addContributionBookSettingNotifierProvider
                                  .notifier)
                              .scanIsbnBarcode(context);
                        },
                      ),
                    ],
                  ),
                  CustomTextFormField(
                    controller: ref
                        .watch(addContributionBookSettingNotifierProvider)
                        .isbnBarcode,
                    obscureText: false,
                    suffixIconData: IconButton(
                      onPressed: ref
                          .watch(addContributionBookSettingNotifierProvider)
                          .isbnBarcode
                          .clear,
                      icon: const Icon(FontAwesomeIcons.eraser),
                    ),
                    maxLength: 13,
                  ),
                  Center(
                    child: CustomFilledButton(
                      width: MediaQuery.of(context).size.width,
                      text: 'CONTRIBUE BOOK',
                      onPress: () {
                        if (ref
                            .watch(addContributionBookSettingNotifierProvider
                                .notifier)
                            .checkInput(context)) {
                          ref
                              .watch(addContributionBookSettingNotifierProvider
                                  .notifier)
                              .contributeBook(
                                context,
                                ContributionBook(
                                  id: '',
                                  name: bookName,
                                  author: bookAuthor,
                                  description: bookDescription,
                                  imageUrl: imageUrl,
                                  delete: false,
                                  verified: false,
                                  normalBarcode: ref
                                      .watch(
                                          addContributionBookSettingNotifierProvider)
                                      .normalBarcode
                                      .text,
                                  isbnBarcode: ref
                                      .watch(
                                          addContributionBookSettingNotifierProvider)
                                      .isbnBarcode
                                      .text,
                                ),
                              );
                          // ref
                          //     .watch(addContributionBookSettingNotifierProvider
                          //         .notifier)
                          //     .setLoadingContributiontBook();
                        }
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
      ),
    );
  }
}
