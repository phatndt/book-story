import 'dart:io';

import 'package:book_exchange/core/app_bar.dart';
import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:book_exchange/presentation/di/post_provider.dart';
import 'package:book_exchange/presentation/views/widgets/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/colors/colors.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: ref.watch(addPostStateNotifierProvider).isLoadingAddPost,
        child: Scaffold(
          backgroundColor: S.colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(S.size.length_50Vertical),
            child: const AppBarImpl(
              title: 'New post',
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: S.size.length_20Vertical,
                horizontal: S.size.length_20,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28.w,
                        backgroundImage: ref
                                .watch(mainAppNotifierProvider)
                                .user
                                .image
                                .isNotEmpty
                            ? NetworkImage(
                                ref.watch(mainAppNotifierProvider).user.image)
                            : const NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSegCgK5aWTTuv_K5TPd10DcJxphcBTBct6R170EamgcCOcYs7LGKVy7ybRc-MCwOcHljg&usqp=CAU"),
                      ),
                      SizedBox(
                        width: S.size.length_10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ref.watch(mainAppNotifierProvider).user.username,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: S.colors.orange,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy, hh:mm').format(
                                DateTime.now(),
                              ),
                              style: TextStyle(
                                fontFamily: 'Lato',
                                color: S.colors.gray_3,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          ref
                              .watch(addPostStateNotifierProvider.notifier)
                              .getListBook(context);
                          // ref
                          //     .watch(getListBookProvider(
                          //         ref.watch(getListBookUseCaseProvider)))
                          //     .when(
                          //       data: (data) {
                          //         List<SelectedListItem> list = data
                          //             .map((e) => SelectedListItem(
                          //                   name: e.name + e.author,
                          //                   value: e.id,
                          //                 ))
                          //             .toList();
                          //       },
                          //       error: (error, stack) => showTopSnackBar(
                          //         context,
                          //         const CustomSnackBar.info(
                          //           message: "Fill up the blank space",
                          //         ),
                          //         displayDuration: const Duration(seconds: 1),
                          //       ),
                          //       loading: () =>
                          //           const CircularProgressIndicator(),
                          //     );
                        },
                        child: Text(ref
                                .watch(addPostStateNotifierProvider)
                                .selectedBookId
                                .isEmpty
                            ? "Link your book"
                            : "Linked book"),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: ref.watch(addPostStateNotifierProvider).content,
                    maxLength: 1000,
                    decoration: const InputDecoration(border: InputBorder.none),
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(
                    height: S.size.length_10Vertical,
                  ),
                  Center(
                    child: Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().screenHeight * 0.3,
                      decoration: BoxDecoration(
                        color: S.colors.accent_8,
                        borderRadius: BorderRadius.all(
                          Radius.circular(S.size.length_8),
                        ),
                        image: ref
                                    .watch(addPostStateNotifierProvider)
                                    .image
                                    .path !=
                                ""
                            ? DecorationImage(
                                image: FileImage(
                                  File(
                                    ref
                                        .watch(addPostStateNotifierProvider)
                                        .image
                                        .path,
                                  ),
                                ),
                                fit: BoxFit.fill,
                              )
                            : null,
                      ),
                      child: TextButton(
                        onPressed: () {
                          ref
                              .watch(addPostStateNotifierProvider.notifier)
                              .showImageSourceActionSheet(context);
                        },
                        child: ref
                                    .watch(addPostStateNotifierProvider)
                                    .image
                                    .path ==
                                ""
                            ? const Text("Add your image")
                            : const Text(
                                "Add your image",
                                style: TextStyle(
                                  color: Colors.transparent,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: S.size.length_20Vertical,
                  ),
                  CustomFilledButton(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight * 0.08,
                    text: "Post",
                    onPress: () {
                      ref
                          .watch(addPostStateNotifierProvider.notifier)
                          .uploadPost(context);
                    },
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
