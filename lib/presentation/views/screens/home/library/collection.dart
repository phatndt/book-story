import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/presentation/views/screens/home/library/book_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_dialogs/material_dialogs.dart';

import '../../../../../core/colors/colors.dart';
import '../../../../di/book_component.dart';
import '../../../../view_models/collection_viewmodels.dart';
import 'book_item.dart';

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
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
            SizedBox(
              height: S.size.length_20Vertical,
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: S.size.length_20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       ToggleButtons(
            //         constraints: BoxConstraints(
            //           minWidth: ScreenUtil().scaleWidth * 120,
            //           minHeight: ScreenUtil().scaleHeight * 40,
            //         ),
            //         children: const [Text("Collection"), Text("Share")],
            //         isSelected: const [true, false],
            //         onPressed: (index) {},
            //         borderRadius: const BorderRadius.all(Radius.circular(20)),
            //       ),
            //       Card(
            //         shape: const CircleBorder(),
            //         child: IconButton(
            //           icon: const Icon(
            //             FontAwesomeIcons.searchengin,
            //           ),
            //           highlightColor: Colors.transparent,
            //           splashColor: Colors.transparent,
            //           onPressed: () {},
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            Center(
              child: Text(
                'YOUR BOOKS',
                style: S.textStyles.collection.bigTitleWithOrange,
              ),
            ),
            SizedBox(
              height: S.size.length_20Vertical,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.refresh(
                    getListBookProvider(ref.watch(getListBookUseCaseProvider))),
                child: ref
                    .watch(getListBookProvider(
                        ref.watch(getListBookUseCaseProvider)))
                    .when(
                      data: (data) {
                        if (data.isEmpty) {
                          return Center(
                            child: Text(
                              'You didn\'t add any books yet!',
                              style: S.textStyles.bigTitle,
                            ),
                          );
                        }
                        return GridView.builder(
                          padding:
                              EdgeInsets.symmetric(horizontal: S.size.length_8),
                          shrinkWrap: true,
                          itemCount: data.length,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: S.size.length_4,
                            childAspectRatio: 0.725,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: S.size.length_4,
                              ),
                              child: BookItem(
                                imageURL: data[index].imageURL,
                                name: data[index].name,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookDetailScreen(
                                              bookId: data[index].id,
                                              bookAuthor: data[index].author,
                                              bookDescription:
                                                  data[index].description,
                                              bookName: data[index].name,
                                              bookRating: data[index].rate,
                                              imageUrl: data[index].imageURL,
                                            )),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stack) {
                        return Center(
                            child: Lottie.asset('assets/images/error.json'));
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
