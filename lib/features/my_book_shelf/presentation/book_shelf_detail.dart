import 'dart:developer';

import 'package:book_story/core/extension/function_extension.dart';
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
import 'add_book_to_shelf.dart';

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
  late int pickerColorIndex;
  late GlobalKey<FormState> _formKey;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    isShowClearIconNameController = false;
    pickedColor = S.colors.primary_3;
    isShowLoading = true;
    isShowError = false;
    bookShelf = null;
    pickerColorIndex = 0;
    books = [];
    _formKey = GlobalKey<FormState>();
    _focusNode = FocusNode();
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
        for (var i = 0; i < S.colors.listColorPicker.length; i++) {
          if (getHexColor(S.colors.listColorPicker[i]) == bookShelf?.color) {
            pickerColorIndex = i;
          }
        }
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
      } else if (next is UIUpdateBookShelfSuccessState) {
        ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
          message: next.message,
        ));
        Navigator.pushNamedAndRemoveUntil(
            context, RoutePaths.main, (route) => false,
            arguments: true);
      } else if (next is UIDeleteBookFromShelfSuccessState) {
        ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
          message: next.message,
        ));
        ref
            .watch(bookShelfDetailStateNotifierProvider.notifier)
            .getBookShelfList(bookShelf!.id);
      }
    });
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isShowLoading,
        child: Scaffold(
          backgroundColor: S.colors.scaffordBackgroundColor,
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
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                          return 'bookshelf_name_must_be_at_least_one_character'
                              .tr();
                        }
                      }
                      return null;
                    },
                    fillColor: S.colors.white,
                    focusNode: _focusNode,
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
                        const IconButton(
                            onPressed: null, icon: Icon(Icons.edit)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  SizedBox(
                    height: 56,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: S.colors.listColorPicker.length,
                      separatorBuilder: (context, index) => SizedBox(
                        width: 8.w,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(28.r),
                          onTap: () {
                            setState(() {
                              pickerColorIndex = index;
                            });
                          },
                          child: Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: S.colors.listColorPicker[index],
                            ),
                            child: pickerColorIndex == index
                                ? Icon(
                                    Icons.check,
                                    color: S.colors.white,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ).isShow(bookShelf?.booksList.isNotEmpty ?? false),
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
                  ).isShow(bookShelf?.booksList.isNotEmpty ?? false),
                  SizedBox(
                    height: 12.h,
                  ).isShow(bookShelf?.booksList.isNotEmpty ?? false),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Divider(
                      height: 2.h,
                      thickness: 1,
                      color: S.colors.primary_3,
                    ),
                  ).isShow(bookShelf?.booksList.isNotEmpty ?? false),
                  SizedBox(
                    height: 24.h,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(24.r),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.addBookToShelf,
                        arguments: AddBookToShelfArgument(
                            bookShelf!.booksList, bookShelf!.id),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: S.colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: S.colors.primary_3,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text('add_book_to_book_shelf'.tr()),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Expanded(child: _bodyBooks()),
                  SizedBox(
                    height: 16.h,
                  ),
                  CustomElevatedButton(
                    onPressed: (nameController.text.trim() != bookShelf?.name ||
                            getHexColor(S.colors
                                    .listColorPicker[pickerColorIndex]) !=
                                bookShelf?.color)
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              _focusNode.unfocus();
                              ref
                                  .watch(bookShelfDetailStateNotifierProvider
                                      .notifier)
                                  .editBookShelf(
                                      bookShelf!.id,
                                      nameController.text.trim(),
                                      getHexColor(S.colors
                                          .listColorPicker[pickerColorIndex]));
                            }
                          }
                        : null,
                    child: Text('update_book_shelf_button'.tr()),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                ],
              ),
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
          return BookWidget(
              book: books[index],
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.bookDetail,
                    arguments: books[index].id);
              },
              onLongPress: () {
                showConfirmDeleteBookFromBookShelfDialog(
                  context,
                  bookShelf!.id,
                  bookShelf!.booksList,
                  books[index].id,
                );
              });
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

  showConfirmDeleteBookFromBookShelfDialog(
    BuildContext context,
    String bookShelfId,
    List<String> listBookId,
    String bookId,
  ) {
    showDialog(
      context: context,
      builder: (context) => BasicAlertDialog(
        title: 'delete_this_book_from_shelf_title'.tr(),
        content: 'delete_this_book_from_shelf_description'.tr(),
        negativeButton: () {
          Navigator.pop(context);
        },
        positiveButton: () {
          Navigator.pop(context);
          ref
              .watch(bookShelfDetailStateNotifierProvider.notifier)
              .deleteBookFromShelf(bookShelfId, listBookId, bookId);
        },
      ),
    );
  }

  String getHexColor(Color color) {
    return color.toString().split('(0x')[1].split(')')[0];
  }
}
