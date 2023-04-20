import 'package:book_story/core/navigation/route_paths.dart';
import 'package:book_story/features/my%20_book/di/my_book_module.dart';
import 'package:book_story/features/my%20_book/domain/entity/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../core/colors/colors.dart';
import '../../../core/presentation/state.dart';

class MyBookScreen extends ConsumerStatefulWidget {
  const MyBookScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MyBookScreenState();
}

class _MyBookScreenState extends ConsumerState<MyBookScreen> {
  late List<Book>? books;
  late bool isShowLoading;
  late bool isShowError;

  @override
  void initState() {
    super.initState();
    books = null;
    isShowLoading = false;
    isShowError = false;
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
        });
      } else if (next is UIStateError) {
        setState(() {
          isShowError = true;
        });
      }
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My collection',
            style: S.textStyles.heading3,
          ),
          backgroundColor: S.colors.white,
          elevation: 0.5,
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
      return const Center(
        child: CircularProgressIndicator(),
      );
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
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        shrinkWrap: true,
        itemCount: books!.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => SizedBox(
          height: 8.h,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: S.size.length_4,
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.bookDetail,
                    arguments: books![index]);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: SizedBox(
                height: 160.h,
                width: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0.5,
                  child: Row(
                    children: [
                      if (books![index].image.contains("https"))
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Image.network(
                            books![index].image,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                books![index].name,
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
                                books![index].author,
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
            ),
          );
        },
      ),
    );
  }
}
