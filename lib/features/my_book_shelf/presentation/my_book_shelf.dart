import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:book_story/features/my_book_shelf/di/book_shelf_module.dart';
import 'package:book_story/features/my_book_shelf/domain/entity/book_shelf.dart';
import 'package:book_story/features/my_book_shelf/presentation/search_book_shelf.dart';
import 'package:book_story/features/my_book_shelf/presentation/widget/book_shelf_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/colors/colors.dart';
import '../../../core/navigation/route_paths.dart';
import '../../../core/presentation/state.dart';

class BookShelfScreen extends ConsumerStatefulWidget {
  const BookShelfScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _BookShelfScreenState();
}

class _BookShelfScreenState extends ConsumerState<BookShelfScreen> {
  late List<BookShelf> bookShelfList;
  late List<BookShelf> tempBookShelfList;
  late bool isShowLoading;
  late bool isShowError;
  late bool isSearching;
  late bool isExpanded;
  late FocusNode focusNode;
  late TextEditingController searchController;
  late bool isShowClearIconSearchController;

  @override
  void initState() {
    super.initState();
    bookShelfList = <BookShelf>[];
    tempBookShelfList = <BookShelf>[];
    isShowClearIconSearchController = false;
    isShowLoading = true;
    isShowError = false;
    focusNode = FocusNode();
    searchController = TextEditingController();
    Future.delayed(Duration.zero, () {
      ref.watch(bookShelfStateNotifierProvider.notifier).getBookShelfList();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bookShelfStateNotifierProvider, (previous, next) {
      if (next is UILoadingState) {
        setState(() {
          isShowLoading = next.loading;
        });
      } else if (next is UISuccessState) {
        setState(() {
          bookShelfList = next.data;
          tempBookShelfList = next.data;
        });
      } else if (next is UIErrorState) {
        setState(() {
          isShowError = true;
        });
      }
    });
    return Scaffold(
      backgroundColor: S.colors.scaffordBackgroundColor,
      appBar: AppBar(
        backgroundColor: S.colors.white,
        elevation: 0.5,
        leading: Image.asset(
          'assets/logo/logo.png',
        ),
        title: Text(
          'Shelfie',
          style: S.textStyles.heading3,
        ),
        actions: [
          IconButton(
            onPressed: bookShelfList.isNotEmpty
                ? () {
                    Navigator.pushNamed(context, RoutePaths.searchBookShelf);
                  }
                : null,
            icon: Icon(
              Icons.search,
              color: S.colors.primary_3,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: RefreshIndicator(
          onRefresh: () async => ref
              .watch(bookShelfStateNotifierProvider.notifier)
              .getBookShelfList(),
          child: _bodyUI(),
        ),
      ),
    );
  }

  Widget _bodyUI() {
    if (isShowError) {
      return Center(
        child: Lottie.asset('assets/images/error.json'),
      );
    }
    if (isShowLoading) {
      return SkeletonListView();
    }
    if (bookShelfList.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 256.h,
              child: Image.asset('assets/feature/shelf/book_shelf.png'),
            ),
            SizedBox(
              height: 64.h,
            ),
            Text(
              'add_some_book_shelf_now'.tr(),
              style: S.textStyles.heading1,
            ),
            SizedBox(
              height: 12.h,
            ),
            CustomElevatedButton(
              child: Text('create_shelf'.tr()),
              onPressed: () {
                Navigator.pushNamed(context, RoutePaths.addBookShelf);
              },
            )
          ],
        ),
      );
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: '${bookShelfList.length}',
                style:
                    S.textStyles.heading3.copyWith(fontWeight: FontWeight.w600),
                children: <TextSpan>[
                  TextSpan(
                    text: bookShelfList.length == 1
                        ? 'shelf'.tr()
                        : 'shelfs'.tr(),
                    style: S.textStyles.heading3
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(24.r),
              onTap: () {
                focusNode.unfocus();
                Navigator.pushNamed(context, RoutePaths.addBookShelf);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: S.colors.primary_1,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: S.colors.primary_3,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text('create_shelf'.tr()),
                  ],
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shrinkWrap: true,
              itemCount: bookShelfList.length,
              scrollDirection: Axis.vertical,
              // separatorBuilder: (context, index) => SizedBox(
              //   height: 8.h,
              // ),
              itemBuilder: (context, index) {
                return BookShelfWidget(
                  name: bookShelfList[index].name,
                  numberOfBooks:
                      bookShelfList[index].booksList.length.toString(),
                  color: bookShelfList[index].color,
                  index: index,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.bookShelfDetail,
                      arguments: BookDetailArguments(
                        bookShelfList[index].id,
                        false,
                      ),
                    );
                  },
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
            ),
          ),
        ),
      ],
    );
  }
}
