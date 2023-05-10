import 'dart:developer';

import 'package:book_story/core/navigation/route_paths.dart';
import 'package:book_story/core/widget/custom_text_form_fill.dart';
import 'package:book_story/features/my%20_book/di/my_book_module.dart';
import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:book_story/features/my%20_book/presentation/state/my_book_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
      if (next is UIStateLoading) {
        setState(() {
          isShowLoading = next.loading;
        });
      } else if (next is UIStateSuccess) {
        setState(() {
          books = next.data;
          temp = next.data;
        });
      } else if (next is UIStateError) {
        log(next.error.toString());
        setState(() {
          isShowError = true;
        });
      } else if (next is DeleteBookSuccess) {
        final snackBar = SuccessSnackBar(
          message: "Delete this book successfully!",
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
          title: Text(
            'Shelfie',
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
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutePaths.addBook,
            );
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: S.colors.white,
        body: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              height: isExpanded ? 80.h : 0.h,
              child: Container(
                color: S.colors.red,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Center(
                  child: CustomTextFormField(
                    focusNode: focusNode,
                    controller: searchController,
                    height: 50,
                    hintText: "Search",
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
      return Center(
        child: Text(
          'Add some books to your collection now!',
          style: S.textStyles.bigTitle,
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
          return BookWidget(book: books![index]);
        },
      ),
    );
  }
}

class BookWidget extends ConsumerStatefulWidget {
  const BookWidget({
    Key? key,
    required this.book,
  }) : super(key: key);

  final Book book;

  @override
  ConsumerState createState() => _BookWidgetState();
}

class _BookWidgetState extends ConsumerState<BookWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.bookDetail,
            arguments: widget.book.id);
      },
      onLongPress: () {
        showBottomSheet(context, widget.book.id);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        height: 160.h,
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0.5,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
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
                // child: CachedNetworkImage(
                //   width: 120.w,
                //   height: 160.h,
                //   fit: BoxFit.fill,
                //   imageUrl: books![index].image,
                //   placeholder: (context, url) => const SkeletonAvatar(),
                //   errorWidget: (context, url, error) => Container(
                //     color: Colors.grey[200],
                //     child: Icon(
                //       Icons.camera_alt,
                //       color: Colors.grey,
                //       size: 36.w,
                //     ),
                //   ),
                // ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
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

  showBottomSheet(BuildContext context, String bookId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(children: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Edit this book'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RoutePaths.editBook,
                arguments: bookId);
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Delete this book'),
          onTap: () {
            Navigator.pop(context);
            showConfirmDeleteBookDialog(context);
          },
        ),
      ]),
    );
  }

  showConfirmDeleteBookDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BasicAlertDialog(
        title: "Delete this book?",
        content: "You want to delete this book",
        negativeButton: () {
          Navigator.pop(context);
        },
        positiveButton: () {
          Navigator.pop(context);
          ref
              .watch(myBookStateNotifierProvider.notifier)
              .deleteBook(widget.book.id);
        },
      ),
    );
  }
}
