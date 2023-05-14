import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:book_story/features/my_book_shelf/di/book_shelf_module.dart';
import 'package:book_story/features/my_book_shelf/domain/entity/book_shelf.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/colors/colors.dart';
import '../../../core/presentation/state.dart';
import '../../my _book/presentation/collection.dart';

class BookShelfScreen extends ConsumerStatefulWidget {
  const BookShelfScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _BookShelfScreenState();
}

class _BookShelfScreenState extends ConsumerState<BookShelfScreen> {
  late List<BookShelf> bookShelfList;
  late bool isShowLoading;
  late bool isShowError;
  late bool isExpanded;
  late FocusNode focusNode;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    bookShelfList = <BookShelf>[];
    isShowLoading = false;
    isShowError = false;
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
        });
      } else if (next is UIErrorState) {
        setState(() {
          isShowError = true;
        });
      }
    });
    return Scaffold(
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
            onPressed: () {
              // if (isExpanded) {
              //   setState(() {
              //     books = temp;
              //   });
              //   searchController.clear();
              //   focusNode.unfocus();
              // } else {
              //   focusNode.requestFocus();
              // }
              // setState(() {
              //   isExpanded = !isExpanded;
              // });
            },
            icon: Icon(
              Icons.search,
              color: S.colors.primary_3,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref
                  .watch(bookShelfStateNotifierProvider.notifier)
                  .getBookShelfList(),
              child: bodyUI(),
            ),
          ),
        ],
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
              'Add some books to your collection now!',
              style: S.textStyles.heading1,
            ),
            SizedBox(
              height: 12.h,
            ),
            CustomElevatedButton(
                child: const Text("Create shelf"), onPressed: () {})
          ],
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        shrinkWrap: true,
        itemCount: bookShelfList.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => SizedBox(
          height: 8.h,
        ),
        itemBuilder: (context, index) {
          return Text("");
        },
      ),
    );
  }
}
