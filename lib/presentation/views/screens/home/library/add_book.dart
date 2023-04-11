import 'dart:io';

import 'package:book_exchange/presentation/views/screens/home/library/book_preview.dart';
import 'package:book_exchange/presentation/views/widgets/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../core/colors/colors.dart';
import '../../../../../core/custom_text_form_fill.dart';
import '../../../../di/book_component.dart';

class AddBookScreen extends ConsumerWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: ref.watch(addBookSettingNotifierProvider).isLoadingAddBook,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(S.size.length_50Vertical),
            child: AppBar(
              centerTitle: true,
              title: const Text("Create a new book"),
              leading: BackButton(onPressed: () {
                ref
                    .watch(addBookSettingNotifierProvider.notifier)
                    .updateImagePath(File(''));
                ref.watch(addBookSettingNotifierProvider.notifier).clearInput();
                Navigator.pop(context);
              }),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: S.size.length_8,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.barcode,
                    ),
                    onPressed: () {
                      ref
                          .watch(addBookSettingNotifierProvider.notifier)
                          .updateImagePath(File(''));
                      ref
                          .watch(addBookSettingNotifierProvider.notifier)
                          .scanBarcode(context);
                    },
                  ),
                ),
              ],
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
                  Text(
                    'Book Cover',
                    style: S.textStyles.titleText,
                  ),
                  SizedBox(
                    height: S.size.length_20Vertical,
                  ),
                  Center(
                    child: Container(
                      width: S.size.length_130,
                      height: S.size.length_170Vertical,
                      decoration: BoxDecoration(
                        color: S.colors.accent_8,
                        borderRadius: BorderRadius.all(
                          Radius.circular(S.size.length_8),
                        ),
                        image: ref
                            .watch(addBookSettingNotifierProvider)
                            .decorationImage,
                      ),
                      child: TextButton(
                        onPressed: () {
                          ref
                              .watch(addBookSettingNotifierProvider.notifier)
                              .showImageSourceActionSheet(context);
                        },
                        child: Icon(
                          FontAwesomeIcons.plus,
                          size: 40,
                          color: S.colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: S.size.length_20Vertical,
                  ),
                  Text(
                    'Name',
                    style: S.textStyles.titleText,
                  ),
                  CustomTextFormField(
                    controller:
                        ref.watch(addBookSettingNotifierProvider).bookName,
                    obscureText: false,
                  ),
                  Text(
                    'Author',
                    style: S.textStyles.titleText,
                  ),
                  CustomTextFormField(
                    controller:
                        ref.watch(addBookSettingNotifierProvider).bookAuthor,
                    obscureText: false,
                  ),
                  Text(
                    'Description',
                    style: S.textStyles.titleText,
                  ),
                  CustomTextFormField(
                    controller: ref
                        .watch(addBookSettingNotifierProvider)
                        .bookDescription,
                    obscureText: false,
                  ),

                  // CustomTextFormField(
                  //   controller:
                  //       ref.watch(addBookSettingNotifierProvider).bookBarcode,
                  //   obscureText: false,
                  // ),
                  // CustomFilledButton(
                  //   width: MediaQuery.of(context).size.width,
                  //   text: 'SCAN BARCODE',
                  //   onPress: () {
                  //     scanBarcodeNormal();
                  //   },
                  // ),
                  // SizedBox(
                  //   height: S.size.length_20Vertical,
                  // ),
                  Text(
                    'Rating',
                    style: S.textStyles.titleText,
                  ),
                  SizedBox(
                    height: S.size.length_10Vertical,
                  ),
                  Center(
                    child: RatingBar(
                      initialRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      updateOnDrag: false,
                      itemCount: 5,
                      unratedColor: S.colors.grey,
                      glowColor: S.colors.orange,
                      ratingWidget: RatingWidget(
                        full: Image.asset('assets/images/heart.png'),
                        half: Image.asset('assets/images/heart_half.png'),
                        empty: Image.asset('assets/images/heart_border.png'),
                      ),
                      itemPadding:
                          EdgeInsets.symmetric(horizontal: S.size.length_8),
                      onRatingUpdate: (rating) {
                        ref.watch(addBookSettingNotifierProvider).bookRating =
                            rating;
                      },
                    ),
                  ),
                  SizedBox(
                    height: S.size.length_10Vertical,
                  ),
                  // Text(
                  //   'Barcode',
                  //   style: S.textStyles.titleText,
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: S.size.length_8Vertical,
                  //   ),
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     color: S.colors.accent_7,
                  //     child: Center(
                  //       child: Text(
                  //         // ref
                  //         //             .watch(addBookSettingNotifierProvider)
                  //         //             .bookBarcode ==
                  //         //         null
                  //         //     ? ref
                  //         //         .watch(addBookSettingNotifierProvider)
                  //         //         .bookBarcode
                  //         //     :
                  //         'Book\'s barcode show here',
                  //         style: S.textStyles.boldTitle,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: S.size.length_20Vertical,
                  ),
                  Center(
                    child: CustomFilledButton(
                      width: MediaQuery.of(context).size.width,
                      text: 'ADD BOOK',
                      onPress: () {
                        if (ref
                            .watch(addBookSettingNotifierProvider.notifier)
                            .checkAddBookInput(context)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookPreviewScreen(
                                bookAuthor: ref
                                    .watch(addBookSettingNotifierProvider)
                                    .bookAuthor
                                    .text,
                                bookName: ref
                                    .watch(addBookSettingNotifierProvider)
                                    .bookName
                                    .text,
                                bookDescription: ref
                                    .watch(addBookSettingNotifierProvider)
                                    .bookDescription
                                    .text,
                                bookRating: ref
                                    .watch(addBookSettingNotifierProvider)
                                    .bookRating,
                                imagePath: ref
                                    .watch(addBookSettingNotifierProvider)
                                    .bookImage
                                    .path,
                              ),
                            ),
                          );
                        }

                        // ref
                        //     .watch(addBookSettingNotifierProvider.notifier)
                        //     .updateImageToCloud(
                        //       context,
                        //     );
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

// Future<String> scanBarcodeNormal() async {
//   String barcodeScanRes;
//   // Platform messages may fail, so we use a try/catch PlatformException.
//   try {
//     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//         '#ff6666', 'Cancel', true, ScanMode.BARCODE);
//     return (barcodeScanRes);
//   } on PlatformException {
//     return barcodeScanRes = 'Failed to get platform version.';
//   }
// }
