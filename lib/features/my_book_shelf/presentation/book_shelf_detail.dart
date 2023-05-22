import 'dart:math';

import 'package:book_story/core/widget/app_bar.dart';
import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my_book_shelf/domain/entity/book_shelf.dart';
import 'package:book_story/features/my_book_shelf/presentation/search_book_shelf.dart';
import 'package:book_story/features/my_book_shelf/presentation/state/book_shelf_detail_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/colors/colors.dart';
import '../../../core/navigation/route_paths.dart';
import '../../../core/presentation/state.dart';
import '../../../core/widget/custom_elevated_button.dart';
import '../../../core/widget/custom_text_form_fill.dart';
import '../../../core/widget/dia_log.dart';
import '../../../core/widget/snack_bar.dart';
import '../../my _book/presentation/collection.dart';
import '../di/book_shelf_module.dart';

class BookShelfDetail extends ConsumerStatefulWidget {
  const BookShelfDetail({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _BookShelfDetailState();
}

class _BookShelfDetailState extends ConsumerState<BookShelfDetail> {
  late Color? pickedColor;
  late TextEditingController nameController;
  late bool isShowClearIconNameController;
  late bool isShowLoading;
  late bool isShowError;
  late BookShelf? bookShelf;
  late List<Book> books;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    isShowClearIconNameController = false;
    pickedColor = S.colors.primary_3;
    isShowLoading = true;
    isShowError = false;
    bookShelf = null;
    books = [];
    Future.delayed(Duration.zero, () {
      ref.watch(bookShelfDetailStateNotifierProvider.notifier).getBookShelfList(
            (ModalRoute.of(context)!.settings.arguments as BookDetailArguments)
                .id,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bookShelfDetailStateNotifierProvider, (previous, next) async {
      if (next is UILoadingState) {
        setState(() {
          isShowLoading = next.loading;
        });
      } else if (next is UISuccessState) {
        setState(() {
          bookShelf = next.data;
          pickedColor = Color(int.parse('0x${bookShelf?.color}'));
          nameController.text = bookShelf?.name ?? '';
        });
      } else if (next is UIErrorState) {
        setState(() {
          isShowError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
          message: next.error.toString(),
        ));
      } else if (next is UISuccessLoadBookList) {
        setState(() {
          books = next.bookList;
        });
      } else if (next is UIDeleteBookShelfSuccessState) {
        ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
          message: next.message,
        ));
        Navigator.pushNamedAndRemoveUntil(
            context, RoutePaths.main, (route) => false,
            arguments: true);
      }
    });
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isShowLoading,
        child: Scaffold(
          appBar: CustomAppBar(
            title: Text(
              'book_shelf_detail'.tr(),
              style: S.textStyles.heading3,
            ),
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: S.colors.primary_3,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showConfirmDeleteBookDialog(context, bookShelf!.id);
                },
                icon: Icon(
                  Icons.delete,
                  color: S.colors.primary_3,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  width: 56.h,
                  backgroundColor: pickedColor,
                  borderRadius: 32,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (buildContext) {
                        return Dialog(
                          child: MaterialColorPicker(
                            colors: fullMaterialColors,
                            selectedColor: pickedColor,
                            onColorChange: (color) =>
                                setState(() => pickedColor = color),
                          ),
                        );
                      },
                    );
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 24.h,
                    child: Center(
                        child: pickedColor == S.colors.primary_3
                            ? const Icon(Icons.light_sharp)
                            : const Icon(Icons.check)),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                CustomTextFormField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        isShowClearIconNameController = true;
                      });
                    } else {
                      setState(() {
                        isShowClearIconNameController = false;
                      });
                    }
                  },
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty) {
                        return 'please_enter_your_book_shelf_name'.tr();
                      } else if (value.length < 2) {
                        return 'bookshelf_name_must_be_at_least_one_character'.tr();
                      }
                    }
                    return null;
                  },
                  hintText: 'book_shelf_name'.tr(),
                  obscureText: false,
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  inputType: TextInputType.name,
                  suffixIconData: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isShowClearIconNameController
                          ? InkWell(
                              child: const Icon(Icons.clear),
                              onTap: () {
                                nameController.clear();
                                setState(() {
                                  isShowClearIconNameController = false;
                                });
                              },
                            )
                          : const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                      const IconButton(onPressed: null, icon: Icon(Icons.edit)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                RichText(
                  text: TextSpan(
                    text: '${bookShelf?.booksList.length.toString()}',
                    style: S.textStyles.heading3
                        .copyWith(fontWeight: FontWeight.w600),
                    children: <TextSpan>[
                      TextSpan(
                        text: bookShelf?.booksList.length == 1
                            ? 'book'.tr()
                            : 'books'.tr(),
                        style: S.textStyles.heading3
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Divider(
                    height: 2.h,
                    thickness: 1,
                    color: S.colors.primary_3,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Expanded(child: _bodyBooks())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyBooks() {
    if (isShowLoading) {
      return const SizedBox();
    }
    if (isShowError) {
      return Center(
        child: Lottie.asset('assets/images/error.json'),
      );
    }
    if (books.isEmpty) {
      return Center(
        child: Text(
          'no_data'.tr(),
          style: S.textStyles.heading3,
        ),
      );
    } else {
      return SizedBox(
          child: ListView.builder(
        shrinkWrap: true,
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookWidget(book: books[index]);
        },
      ));
    }
  }

  showConfirmDeleteBookDialog(BuildContext context, String bookShelfId) {
    showDialog(
      context: context,
      builder: (context) => BasicAlertDialog(
        title: 'delete_this_book_shelf'.tr(),
        content: 'you_want_to_delete_this_book_shelf'.tr(),
        negativeButton: () {
          Navigator.pop(context);
        },
        positiveButton: () {
          Navigator.pop(context);
          ref
              .watch(bookShelfDetailStateNotifierProvider.notifier)
              .deleteBookShelf(bookShelfId);
        },
      ),
    );
  }
}
