import 'dart:io';

import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/app_bar.dart';
import '../../../../core/colors/colors.dart';
import '../../../../domain/entities/post.dart';
import '../../../di/post_provider.dart';
import '../../widgets/filled_button.dart';

class EditPostScreen extends ConsumerWidget {
  const EditPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: ref.watch(editPostStateNotifierProvider).isLoadingEditPost,
        child: Scaffold(
          backgroundColor: S.colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(S.size.length_50Vertical),
            child: AppBarImpl(
              title: 'Edit post',
              onPressed: () {
                Navigator.pop(context);
                ref.refresh(editPostStateNotifierProvider);
              },
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
                        backgroundImage: NetworkImage(
                            ref.watch(mainAppNotifierProvider).user.image),
                      ),
                      SizedBox(
                        width: S.size.length_10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ref.watch(mainAppNotifierProvider).user.username,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: S.colors.orange,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(ref
                                    .watch(editPostStateNotifierProvider)
                                    .post
                                    .createDate),
                              ),
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
                      const Expanded(child: SizedBox()),
                      TextButton(
                        onPressed: () async {
                          ref
                              .watch(editPostStateNotifierProvider.notifier)
                              .getListBook(context);
                        },
                        child: Text(ref
                                .watch(editPostStateNotifierProvider)
                                .selectedBookId
                                .isEmpty
                            ? "Link your book"
                            : "Linked book"),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller:
                        ref.watch(editPostStateNotifierProvider).content,
                    maxLength: 1000,
                    decoration: const InputDecoration(border: InputBorder.none),
                    maxLines: null,
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                    onChanged: (value) {
                      ref
                          .watch(editPostStateNotifierProvider.notifier)
                          .isEnableUpdateButton();
                    },
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
                                .watch(editPostStateNotifierProvider)
                                .image
                                .path
                                .isNotEmpty
                            ? DecorationImage(
                                image: FileImage(
                                  File(
                                    ref
                                        .watch(editPostStateNotifierProvider)
                                        .image
                                        .path,
                                  ),
                                ),
                                fit: BoxFit.fill,
                              )
                            : DecorationImage(
                                image: NetworkImage(ref
                                    .watch(editPostStateNotifierProvider)
                                    .imagePath),
                                fit: BoxFit.fill,
                              ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          ref
                              .watch(editPostStateNotifierProvider.notifier)
                              .showImageSourceActionSheet(context);
                        },
                        child: (ref
                                    .watch(editPostStateNotifierProvider)
                                    .image
                                    .path
                                    .isEmpty &&
                                ref
                                    .watch(editPostStateNotifierProvider)
                                    .imagePath
                                    .isEmpty)
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
                    onPress: ref
                            .watch(editPostStateNotifierProvider)
                            .isEnableButton
                        ? () {
                            ref
                                .watch(editPostStateNotifierProvider.notifier)
                                .receiveEventEditPost(context);
                          }
                        : null,
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
