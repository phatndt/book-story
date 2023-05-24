import 'package:book_story/core/widget/custom_elevated_button.dart';
import 'package:book_story/core/widget/snack_bar.dart';
import 'package:book_story/features/my_book_shelf/di/book_shelf_module.dart';
import 'package:book_story/features/my_book_shelf/presentation/state/add_book_to_shelf_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/colors/colors.dart';
import '../../../core/presentation/state.dart';
import '../../../core/widget/app_bar.dart';
import '../../../core/widget/custom_text_form_fill.dart';
import '../../my _book/domain/entity/book.dart';
import '../../my _book/presentation/collection.dart';

class AddBookToShelfScreen extends ConsumerStatefulWidget {
  const AddBookToShelfScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddBookToShelfScreenState();
}

class _AddBookToShelfScreenState extends ConsumerState<AddBookToShelfScreen> {
  late List<Book>? books;
  late List<Book>? temp;
  late bool isShowLoading;
  late bool isShowError;
  late bool isExpanded;
  late FocusNode focusNode;
  late TextEditingController searchController;
  late bool isShowClearIconSearchController;
  late List<String> selectedBook;

  @override
  void initState() {
    super.initState();
    books = null;
    temp = null;
    isShowLoading = false;
    isShowError = false;
    isExpanded = false;
    selectedBook = [];
    focusNode = FocusNode();
    searchController = TextEditingController();
    isShowClearIconSearchController = false;
    Future.delayed(Duration.zero, () {
      ref.watch(addBookToShelfNotifierProvider.notifier).getBook(
          (ModalRoute.of(context)!.settings.arguments as AddBookToShelfArgument)
              .bookIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(addBookToShelfNotifierProvider, (previous, next) {
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
        setState(() {
          isShowError = true;
        });
      } else if (next is UIUpdateBooksOfShelfSuccessState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SuccessSnackBar(
            message: 'add_book_to_book_shelf_success'.tr(),
          ),
        );
        Navigator.pop(context);
        ref
            .watch(bookShelfDetailStateNotifierProvider.notifier)
            .getBookShelfList((ModalRoute.of(context)!.settings.arguments
                    as AddBookToShelfArgument)
                .bookShelfId);

        ref
            .watch(bookShelfStateNotifierProvider.notifier).getBookShelfList();
      }
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: S.colors.scaffordBackgroundColor,
        appBar: CustomAppBar(
          title: Text(
            'add_book_to_book_shelf'.tr(),
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
                      books = temp;
                    });
                  } else {
                    setState(() {
                      books = temp
                          ?.where((element) =>
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
              Expanded(child: _bodyUI()),
              CustomElevatedButton(
                onPressed: selectedBook.isEmpty
                    ? null
                    : () {
                        final booksId = (ModalRoute.of(context)!
                                .settings
                                .arguments as AddBookToShelfArgument)
                            .bookIds;
                        booksId.addAll(selectedBook);
                        ref
                            .watch(addBookToShelfNotifierProvider.notifier)
                            .addBookToShelf(
                              (ModalRoute.of(context)!.settings.arguments
                                      as AddBookToShelfArgument)
                                  .bookShelfId,
                              booksId,
                            );
                      },
                child: Text(
                  'add_book_to_book_shelf'.tr(),
                ),
              )
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
    if (books == null) {
      return const SizedBox();
    }
    if (books!.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        child: Center(
          child: Text(
            'no_data'.tr(),
            style: S.textStyles.bigTitle,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shrinkWrap: true,
        itemCount: books!.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => SizedBox(
          height: 8.h,
        ),
        itemBuilder: (context, index) {
          return CheckboxListTile(
            value: selectedBook.contains(books![index].id),
            onChanged: (value) {
              if (value!) {
                setState(() {
                  selectedBook.add(books![index].id);
                });
              } else {
                setState(() {
                  selectedBook.remove(books![index].id);
                });
              }
            },
            title: BookWidget(book: books![index]),
          );
        },
      ),
    );
  }
}

class AddBookToShelfArgument {
  final List<String> bookIds;
  final String bookShelfId;

  AddBookToShelfArgument(this.bookIds, this.bookShelfId);
}
