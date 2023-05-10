import 'dart:async';
import 'dart:developer';

import 'package:book_story/core/extension/function_extension.dart';
import 'package:book_story/features/my%20_book/di/my_book_module.dart';
import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:skeletons/skeletons.dart';

import '../../../core/colors/colors.dart';
import '../../../core/presentation/state.dart';
import '../../../core/widget/snack_bar.dart';

class ReadBookFile extends ConsumerStatefulWidget {
  const ReadBookFile({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ReadBookFileState();
}

class _ReadBookFileState extends ConsumerState<ReadBookFile> {
  late int totalPage;
  late int currentPage;
  late Book? book;
  late bool isShowLoading;
  late Completer<PDFViewController> _pdfViewController;

  @override
  void initState() {
    super.initState();
    isShowLoading = false;
    book = null;
    totalPage = 0;
    currentPage = 0;
    _pdfViewController = Completer<PDFViewController>();
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      ref
          .watch(getBookDetailStateNotifierProvider.notifier)
          .getBookDetail(args);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getBookDetailStateNotifierProvider, (previous, next) {
      if (next is UIStateLoading) {
        setState(() {
          isShowLoading = next.loading;
        });
      } else if (next is UIStateSuccess) {
        setState(() {
          book = next.data;
        });
      } else if (next is UIStateError) {
        final snackBar = ErrorSnackBar(
          message: next.error.toString(),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      }
    });
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isShowLoading,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: S.colors.white,
            elevation: 0.2,
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: S.colors.primary_3,
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  setState(() {
                    currentPage = 0;
                  });
                  final pdfViewController = await _pdfViewController.future;
                  pdfViewController.setPage(0);
                  ref
                      .watch(readBookFileStateNotifierProvider.notifier)
                      .updateReadFilePageBook(book!.id, 0);
                },
                icon: Icon(
                  Icons.lock_reset_outlined,
                  color: S.colors.primary_3,
                ),
                tooltip: "Reset to first page",
              ),
              TextButton(
                onPressed: () {
                  ref
                      .watch(readBookFileStateNotifierProvider.notifier)
                      .updateReadFilePageBook(book!.id, currentPage);
                },
                child: const Text("Save current page"),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: SizedBox(
              height: 56.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      final pdfViewController = await _pdfViewController.future;
                      pdfViewController.setPage(currentPage - 1);
                    },
                    icon: Icon(
                      Icons.chevron_left,
                      color: S.colors.primary_3,
                      size: 32,
                    ),
                    tooltip: "Reset to first page",
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      "Page: $currentPage/$totalPage",
                      style: S.textStyles.paragraph,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final pdfViewController = await _pdfViewController.future;
                      pdfViewController.setPage(currentPage + 1);
                    },
                    icon: Icon(
                      Icons.chevron_right,
                      color: S.colors.primary_3,
                      size: 32,
                    ),
                    tooltip: "Reset to first page",
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: S.colors.white,
          body: _bodyUI(),
        ),
      ),
    );
  }

  Widget _bodyUI() {
    if (book.isNull()) {
      return Container();
    }
    return Container(
      color: Colors.grey,
      child: PDF(
        onViewCreated: (PDFViewController pdfViewController) {
          _pdfViewController.complete(pdfViewController);
        },
        defaultPage: book!.readFilePage,
        onPageChanged: (page, total) {
          if (!total.isNull()) {
            setState(() {
              totalPage = total!;
            });
          }
          if (!page.isNull()) {
            setState(() {
              currentPage = page!;
            });
          }
        },
      ).cachedFromUrl(
        book!.readFile,
        placeholder: (double progress) =>
            Center(child: Text('Loading file: $progress %')),
        errorWidget: (dynamic error) =>
            const Center(child: Text('Something wrong! Please try later')),
      ),
    );
  }
}
