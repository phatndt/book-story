import 'package:book_story/features/my_book_shelf/di/book_shelf_module.dart';
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
import '../../../core/widget/app_bar.dart';
import '../../../core/widget/custom_text_form_fill.dart';
import '../../../core/widget/snack_bar.dart';
import '../domain/entity/book_shelf.dart';

class SearchBookShelfScreen extends ConsumerStatefulWidget {
  const SearchBookShelfScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SearchBookShelfScreenState();
}

class _SearchBookShelfScreenState extends ConsumerState<SearchBookShelfScreen> {
  late List<BookShelf> bookShelfList;
  late List<BookShelf> tempBookShelfList;
  late TextEditingController searchController;
  late bool isShowClearIconSearchController;
  late FocusNode focusNode;
  late bool isShowError;
  late bool isShowLoading;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    bookShelfList = <BookShelf>[];
    tempBookShelfList = <BookShelf>[];
    searchController = TextEditingController();
    isShowClearIconSearchController = false;
    focusNode.requestFocus();
    isShowLoading = true;
    isShowError = false;
    Future.delayed(Duration.zero, () {
      ref
          .watch(searchBookShelfNotifierProvider.notifier)
          .getBookShelfFromLocal();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchBookShelfNotifierProvider, (previous, next) {
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
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(
            'search_book_shelf_title'.tr(),
            style: S.textStyles.heading3,
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: S.colors.primary_3,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            children: [
              CustomTextFormField(
                enabled: !isShowError,
                focusNode: focusNode,
                controller: searchController,
                height: 50,
                hintText: 'search'.tr(),
                obscureText: false,
                prefixIconData: const Icon(Icons.search),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      bookShelfList = tempBookShelfList;
                    });
                  } else {
                    setState(() {
                      bookShelfList = tempBookShelfList
                          .where((element) =>
                              element.name.toLowerCase().contains(value))
                          .toList();
                    });
                  }
                },
                suffixIconData: isShowClearIconSearchController
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
              Expanded(child: _bodyUI())
            ],
          ),
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
      return Center(
        child: Text('no_data'.tr()),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shrinkWrap: true,
          itemCount: bookShelfList.length,
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => SizedBox(
            height: 8.h,
          ),
          itemBuilder: (context, index) {
            return BookShelfWidget(
              name: bookShelfList[index].name,
              numberOfBooks: bookShelfList[index].booksList.length.toString(),
              color: bookShelfList[index].color,index: index,
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.bookShelfDetail,
                    arguments: BookDetailArguments(
                      bookShelfList[index].id,
                      true,
                    ));
              },
            );
          },
        ),
      );
    }
  }
}

class BookDetailArguments {
  final String id;
  final bool isSearch;

  BookDetailArguments(
    this.id,
    this.isSearch,
  );
}
