import 'package:book_exchange/core/widget/footer_widget.dart';
import 'package:book_exchange/presentation/views/screens/home/library/add_contribution_book.dart';
import 'package:book_exchange/presentation/views/screens/home/library/edit_book.dart';
import 'package:book_exchange/presentation/views/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../core/colors/colors.dart';
import '../../../../di/book_component.dart';

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({
    required this.bookId,
    required this.bookName,
    required this.bookAuthor,
    required this.bookDescription,
    required this.bookRating,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  final String bookId;
  final String bookName;
  final String bookAuthor;
  final String bookDescription;
  final double bookRating;
  final String imageUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall:
            ref.watch(bookDetailSettingNotifierProvider).isLoadingBookDetail,
        child: Scaffold(
          backgroundColor: S.colors.gray_6,
          body: Padding(
            padding: EdgeInsets.only(top: S.size.length_25Vertical),
            child: Column(
              children: [
                FooterScreen(
                  buttonContent: "context",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: S.size.length_10Vertical,
                ),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: S.size.length_64Vertical,
                        child: Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: S.size.length_25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: S.size.length_20Vertical,
                              ),
                              Row(
                                children: [
                                  const Expanded(child: SizedBox()),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  width: 0.8,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "Author",
                                              style: S.textStyles.collection
                                                  .bigTitle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            height: S.size.length_8,
                                          ),
                                          Text(
                                            bookAuthor,
                                            style: S.textStyles.collection
                                                .smallTitle,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: S.size.length_20Vertical,
                              ),
                              Row(
                                children: [
                                  const Expanded(child: SizedBox()),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: S.size.length_4,
                                          ),
                                          child: ClipOval(
                                            child: Material(
                                              color: S.colors
                                                  .orange, // Button color
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddContributionBookScreen(
                                                        bookAuthor: bookAuthor,
                                                        bookDescription:
                                                            bookDescription,
                                                        bookName: bookName,
                                                        imageUrl: imageUrl,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: SizedBox(
                                                  width: S.size.length_40,
                                                  height:
                                                      S.size.length_40Vertical,
                                                  child: Icon(
                                                    FontAwesomeIcons
                                                        .cloudArrowUp,
                                                    color: Colors.white,
                                                    size:
                                                        ScreenUtil().scaleText *
                                                            16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: S.size.length_4,
                                          ),
                                          child: ClipOval(
                                            child: Material(
                                              color: S.colors
                                                  .orange, // Button color
                                              child: InkWell(
                                                splashColor: S.colors
                                                    .navyBlue, // Splash color
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditBookScreen(
                                                        bookId: bookId,
                                                        bookAuthor: bookAuthor,
                                                        bookDescription:
                                                            bookDescription,
                                                        bookName: bookName,
                                                        bookRating: bookRating,
                                                        imageUrl: imageUrl,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: SizedBox(
                                                  width: S.size.length_40,
                                                  height:
                                                      S.size.length_40Vertical,
                                                  child: Icon(
                                                    FontAwesomeIcons.pencil,
                                                    color: Colors.white,
                                                    size:
                                                        ScreenUtil().scaleText *
                                                            16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: S.size.length_4,
                                          ),
                                          child: ClipOval(
                                            child: Material(
                                              color: S.colors
                                                  .orange, // Button color
                                              child: InkWell(
                                                splashColor: S.colors
                                                    .navyBlue, // Splash color
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (builder) =>
                                                        CustomAlertDialog(
                                                      action: () {
                                                        ref
                                                            .watch(
                                                                editBookSettingNotifierProvider
                                                                    .notifier)
                                                            .deleteBookByBookId(
                                                                bookId,
                                                                context);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      action1Title: 'Yes',
                                                      action2Title: 'No',
                                                      content:
                                                          'You want to delete this book?',
                                                      title: 'DELETE',
                                                    ),
                                                  );
                                                },
                                                child: SizedBox(
                                                  width: S.size.length_40,
                                                  height:
                                                      S.size.length_40Vertical,
                                                  child: Icon(
                                                    FontAwesomeIcons.trash,
                                                    color: Colors.white,
                                                    size:
                                                        ScreenUtil().scaleText *
                                                            16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: S.size.length_25Vertical,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: S.size.length_16),
                                child: RatingBarIndicator(
                                  rating: bookRating,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 25.0,
                                  direction: Axis.horizontal,
                                ),
                              ),
                              SizedBox(
                                height: S.size.length_20Vertical,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.8,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'About this book',
                                  style: S.textStyles.collection.bigTitle,
                                ),
                              ),
                              SizedBox(
                                height: S.size.length_10Vertical,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: S.colors.gray_6,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        S.size.length_8,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: S.size.length_10,
                                      vertical: S.size.length_8Vertical,
                                      // vertical: S.size.length_20,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        text: bookDescription,
                                        style:
                                            S.textStyles.bookDetail.description,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: S.size.length_10Vertical,
                        left: S.size.length_25,
                        child: Card(
                          elevation: 4,
                          child: Container(
                            width: S.size.length_150,
                            height: S.size.length_200Vertical,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: S.colors.black,
                                width: 0.1,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  S.size.length_8,
                                ),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
