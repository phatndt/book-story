import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/colors/colors.dart';
import '../../../../di/book_component.dart';
import '../../../widgets/filled_button.dart';

class BookPreviewScreen extends ConsumerWidget {
  const BookPreviewScreen({
    Key? key,
    required this.imagePath,
    required this.bookName,
    required this.bookAuthor,
    required this.bookDescription,
    required this.bookRating,
  }) : super(key: key);

  final String imagePath;
  final String bookName;
  final String bookAuthor;
  final String bookDescription;
  final double bookRating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: S.colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Preview Your Book"),
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: Center(
          child: SingleChildScrollView(
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
                  // Text(
                  //   'Book Cover',
                  //   style: S.textStyles.titleText,
                  // ),
                  SizedBox(
                    height: S.size.length_20Vertical,
                  ),
                  Center(
                    child: Material(
                      borderRadius: BorderRadius.all(
                        Radius.circular(S.size.length_8),
                      ),
                      elevation: 5,
                      child: Container(
                        width: S.size.length_150,
                        height: S.size.length_200Vertical,
                        decoration: BoxDecoration(
                            color: S.colors.accent_8,
                            borderRadius: BorderRadius.all(
                              Radius.circular(S.size.length_8),
                            ),
                            image: DecorationImage(
                              image: FileImage(
                                File(imagePath),
                              ),
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: S.size.length_10Vertical,
                  ),
                  Center(
                    child: RatingBarIndicator(
                      rating: bookRating,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 30.0,
                      direction: Axis.horizontal,
                    ),
                  ),
                  SizedBox(
                    height: S.size.length_10Vertical,
                  ),
                  Text(
                    'Book Name:  ',
                    style: S.textStyles.collection.biggerSmallTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    bookName,
                    style: S.textStyles.collection.smallTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: S.size.length_8Vertical,
                  ),
                  Text(
                    'Author:  ',
                    style: S.textStyles.collection.biggerSmallTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    bookAuthor,
                    style: S.textStyles.collection.smallTitle,
                  ),
                  SizedBox(
                    height: S.size.length_20Vertical,
                  ),

                  Text(
                    'Description:  ',
                    style: S.textStyles.collection.biggerSmallTitle,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: S.colors.gray_6,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            S.size.length_8,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: S.size.length_8,
                          vertical: S.size.length_8Vertical,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: bookDescription,
                            style: S.textStyles.collection.smallTitle,
                          ),
                        ),
                      ),
                    ),
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
                  // Text(
                  //   'Rating',
                  //   style: S.textStyles.titleText,
                  // ),
                  SizedBox(
                    height: S.size.length_8Vertical,
                  ),
                  // Text(
                  //   'Barcode: ',
                  //   style: S.textStyles.collection.biggerSmallTitle,
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
                      text: 'UPLOAD BOOK',
                      onPress: () {
                        ref
                            .watch(addBookSettingNotifierProvider.notifier)
                            .uploadBook(
                              context,
                            );
                      },
                    ),
                  ),
                  SizedBox(
                    height: S.size.length_50Vertical,
                  ),
                  // SizedBox(
                  //   height: S.size.length_40Vertical,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
