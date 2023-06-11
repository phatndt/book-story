import 'dart:developer';

import 'package:book_story/core/navigation/route_paths.dart';
import 'package:book_story/core/widget/custom_text_form_fill.dart';
import 'package:book_story/features/my%20_book/di/my_book_module.dart';
import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/presentation/state/my_book_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/colors/colors.dart';
import '../../../core/presentation/state.dart';
import '../../../core/widget/dia_log.dart';
import '../../../core/widget/snack_bar.dart';

class MyBookScreen extends ConsumerStatefulWidget {
  const MyBookScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MyBookScreenState();
}

class _MyBookScreenState extends ConsumerState<MyBookScreen> {
  late List<Book>? books;
  late List<Book>? temp;
  late bool isShowLoading;
  late bool isShowError;
  late bool isExpanded;
  late FocusNode focusNode;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    books = null;
    temp = null;
    isShowLoading = false;
    isShowError = false;
    isExpanded = false;
    focusNode = FocusNode();
    searchController = TextEditingController();
    Future.delayed(Duration.zero, () {
      ref.watch(myBookStateNotifierProvider.notifier).getBook();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(myBookStateNotifierProvider, (previous, next) {
      if (next is UILoadingState) {
        setState(() {
          isShowLoading = next.loading;
        });
      } else if (next is UISuccessState) {
        setState(() {
          books = next.data;
          temp = next.data;
        });
      } else if (next is UIErrorState) {
        log(next.error.toString());
        setState(() {
          isShowError = true;
        });
      } else if (next is DeleteBookSuccess) {
        final snackBar = SuccessSnackBar(
          message: 'delete_book_successfully'.tr(),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        ref.watch(myBookStateNotifierProvider.notifier).getBook();
      }
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: S.colors.white,
          elevation: 0.5,
          leading: Image.asset(
            'assets/logo/logo.png',
          ),
          title: Text(
            'shelfie'.tr(),
            style: S.textStyles.heading3,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (isExpanded) {
                    setState(() {
                      books = temp;
                    });
                    searchController.clear();
                    focusNode.unfocus();
                  } else {
                    focusNode.requestFocus();
                  }
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: S.colors.primary_3,
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: S.colors.primary_3,
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutePaths.addBook,
            );
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: const Color(0xffF2F6FA),
        body: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              height: isExpanded ? 80.h : 0.h,
              child: Container(
                color: S.colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Center(
                  child: CustomTextFormField(
                    focusNode: focusNode,
                    controller: searchController,
                    height: 50,
                    hintText: 'search'.tr(),
                    obscureText: false,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          books = temp;
                        });
                      } else {
                        setState(() {
                          books = temp!
                              .where((element) =>
                                  element.name.toLowerCase().contains(value))
                              .toList();
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async =>
                    ref.watch(myBookStateNotifierProvider.notifier).getBook(),
                child: bodyUI(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyUI() {
    if (isShowError) {
      return Center(
        child: Lottie.asset('assets/images/error.json'),
      );
    }
    if (isShowLoading) {
      return SkeletonListView();
    }
    if (books == null) {
      return const SizedBox();
    }
    if (books!.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        child: Center(
          child: Text(
            'add_some_books_to_your_collection_now'.tr(),
            style: S.textStyles.bigTitle,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        shrinkWrap: true,
        itemCount: books!.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => SizedBox(
          height: 8.h,
        ),
        itemBuilder: (context, index) {
          return BookWidget(
            book: books![index],
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.bookDetail,
                  arguments: books![index].id);
            },
            onLongPress: () {
              showBookBottomSheet(context, books![index].id);
            },
          );
        },
      ),
    );
  }

  showBookBottomSheet(BuildContext context, String bookId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(children: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: Text('edit_book'.tr()),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RoutePaths.editBook,
                arguments: bookId);
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: Text('delete_book'.tr()),
          onTap: () {
            Navigator.pop(context);
            showConfirmDeleteBookDialog(context, bookId);
          },
        ),
      ]),
    );
  }

  showConfirmDeleteBookDialog(BuildContext context, String bookId) {
    showDialog(
      context: context,
      builder: (context) => BasicAlertDialog(
        title: 'delete_this_book'.tr(),
        content: 'delete_this_book_description'.tr(),
        negativeButton: () {
          Navigator.pop(context);
        },
        positiveButton: () {
          Navigator.pop(context);
          ref.watch(myBookStateNotifierProvider.notifier).deleteBook(bookId);
        },
      ),
    );
  }
}

class BookWidget extends ConsumerStatefulWidget {
  const BookWidget({Key? key, required this.book, this.onTap, this.onLongPress})
      : super(key: key);

  final Book book;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  ConsumerState createState() => _BookWidgetState();
}

class _BookWidgetState extends ConsumerState<BookWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        height: 160.h,
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0.5,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: SizedBox(
                  width: 120.w,
                  height: 160.h,
                  child: Image.network(
                    widget.book.image,
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SkeletonAvatar();
                    },
                    errorBuilder: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                        size: 36.w,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.name,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: S.textStyles.heading2
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        widget.book.author,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: S.textStyles.heading3,
                      ),
                      SizedBox(
                        height: 48.h,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
