import 'dart:developer';

import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/presentation/di/post_provider.dart';
import 'package:book_exchange/presentation/views/widgets/post/post_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_dialogs/material_dialogs.dart';

import '../../../../core/colors/colors.dart';

class MainPostScreen extends ConsumerWidget {
  const MainPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: S.colors.white,
        body: Padding(
          padding: EdgeInsets.only(
            top: S.size.length_20Vertical,
            left: S.size.length_10,
            right: S.size.length_10,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo/logo.png',
                    scale: 2,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutePaths.addPost);
                    },
                    child: Icon(
                      FontAwesomeIcons.plus,
                      color: Colors.white,
                      size: S.size.length_20,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      primary: S.colors.mainColor,
                      padding: EdgeInsets.all(S.size.length_8),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: S.size.length_10,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => ref.refresh(getAllPostFutureProvider(
                      ref.watch(getAllPostPostUseCase))),
                  child: ref
                      .watch(getAllPostFutureProvider(
                          ref.watch(getAllPostPostUseCase)))
                      .when(
                        data: (data) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (buildContext, index) {
                                return PostItemWidget(
                                  combinationPost: data[index],
                                  onTap: () {
                                    ref
                                        .watch(
                                            postDetailNotifierProvider.notifier)
                                        .setCombinationPost(
                                          data[index],
                                        );
                                    Navigator.pushNamed(
                                      context,
                                      RoutePaths.postDetail,
                                    );
                                  },
                                );
                              });
                        },
                        error: (error, stack) {
                          log(error.toString());
                          return Center(
                              child: Lottie.asset('assets/images/error.json'));
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                  // onRefresh: () async {
                  //   log("1");
                  // },
                  // child: Text("dsdsd"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
