import 'dart:io';

import 'package:book_exchange/presentation/views/widgets/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../core/colors/colors.dart';
import '../../../../../core/custom_text_form_fill.dart';
import '../../../../di/book_component.dart';

class EditBookScreen extends ConsumerWidget {
  const EditBookScreen({
    required this.bookId,
    required this.bookName,
    required this.bookAuthor,
    required this.bookDescription,
    required this.bookRating,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  final String bookId;
  final String bookName;
  final String bookAuthor;
  final String bookDescription;
  final double bookRating;
  final String imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(editBookSettingNotifierProvider).bookRating = bookRating;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall:
            ref.watch(editBookSettingNotifierProvider).isLoadingEditBook,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(S.size.length_50),
            child: AppBar(
              centerTitle: true,
              title: const Text("Edit Your Book"),
              leading: BackButton(onPressed: () {
                ref
                    .watch(editBookSettingNotifierProvider.notifier)
                    .updateImagePath(XFile(''));
                ref
                    .watch(editBookSettingNotifierProvider.notifier)
                    .clearInput();
                Navigator.pop(context);
              }),
              // actions: [
              //   IconButton(
              //     icon: const Icon(
              //       FontAwesomeIcons.trashCan,
              //     ),
              //     onPressed: () {
              //       deletePress(context, () {
              //         ref
              //             .watch(editBookSettingNotifierProvider.notifier)
              //             .deleteBookByBookId(bookId, context);
              //       });
              //     },
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
                        'Book Cover',
                        style: S.textStyles.titleText,
                      ),
                      // ReCustomElevatedButton(
                      //   height: 40,
                      //   width: 100,
                      //   text: "DELETE",
                      //   onPress: () {
                      //     showDialog(
                      //       context: context,
                      //       barrierDismissible: true,
                      //       builder: (builder) => CustomAlertDialog(
                      //         action: () {
                      //           //deletethisbook
                      //           ref
                      //               .watch(editBookSettingNotifierProvider
                      //                   .notifier)
                      //               .deleteBookByBookId(this.bookId, context);
                      //         },
                      //         action1Title: 'Yes',
                      //         action2Title: 'No',
                      //         content: 'You want to delete this book?',
                      //         title: 'DELETE',
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
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
                                    .watch(editBookSettingNotifierProvider)
                                    .bookImage
                                    .path ==
                                ''
                            ? DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.fill,
                              )
                            : DecorationImage(
                                image: FileImage(
                                  File(
                                    ref
                                        .watch(editBookSettingNotifierProvider)
                                        .bookImage
                                        .path,
                                  ),
                                ),
                                fit: BoxFit.fill,
                              ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          ref
                              .watch(editBookSettingNotifierProvider.notifier)
                              .showImageSourceActionSheet(context);
                        },
                        child:
                            // ? Icon(
                            //     FontAwesomeIcons.plus,
                            //     size: 40,
                            //     color: S.colors.grey,
                            //   )
                            // :
                            const Icon(
                          FontAwesomeIcons.plus,
                          color: Colors.transparent,
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
                    hintText: bookName,
                    controller:
                        ref.watch(editBookSettingNotifierProvider).bookName,
                    obscureText: false,
                  ),
                  Text(
                    'Author',
                    style: S.textStyles.titleText,
                  ),
                  CustomTextFormField(
                    hintText: bookAuthor,
                    controller:
                        ref.watch(editBookSettingNotifierProvider).bookAuthor,
                    obscureText: false,
                  ),
                  Text(
                    'Description',
                    style: S.textStyles.titleText,
                  ),
                  CustomTextFormField(
                    hintText: bookDescription,
                    controller: ref
                        .watch(editBookSettingNotifierProvider)
                        .bookDescription,
                    obscureText: false,
                  ),
                  Text(
                    'Rating',
                    style: S.textStyles.titleText,
                  ),
                  SizedBox(
                    height: S.size.length_10Vertical,
                  ),
                  Center(
                    child: RatingBar(
                      initialRating: bookRating,
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
                        ref.watch(editBookSettingNotifierProvider).bookRating =
                            rating;
                      },
                    ),
                  ),
                  SizedBox(
                    height: S.size.length_40Vertical,
                  ),
                  Center(
                    child: CustomFilledButton(
                      width: MediaQuery.of(context).size.width,
                      text: 'EDIT BOOK',
                      onPress: () {
                        if (ref
                            .watch(editBookSettingNotifierProvider.notifier)
                            .checkEditBookInput(context, bookName, bookAuthor,
                                bookDescription, bookRating)) {
                          ref
                              .watch(editBookSettingNotifierProvider.notifier)
                              .editBook(context, imageUrl, bookId);
                        }

                        // ref
                        //     .watch(editBookSettingNotifierProvider.notifier)
                        //     .updateImageToCloudinary(
                        //       context,
                        //     );
                      },
                    ),
                  ),
                  SizedBox(
                    height: S.size.length_40Vertical,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
