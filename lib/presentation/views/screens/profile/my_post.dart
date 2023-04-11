import 'dart:io';

import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/domain/entities/combination_post.dart';
import 'package:book_exchange/domain/entities/user_post.dart';
import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:book_exchange/presentation/di/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_dialogs/material_dialogs.dart';

import '../../../../core/colors/colors.dart';
import '../../../../core/widget/footer_widget.dart';
import '../../widgets/post/post_item.dart';

class MyPost extends ConsumerWidget {
  const MyPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: S.size.length_10Vertical,
            ),
            FooterScreen(
              buttonContent: "context",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: S.size.length_10Vertical,
            ),
            ref
                .watch(getMyPostFutureProvider(ref.watch(getMyPostUseCase)))
                .when(
                  data: (data) {
                    return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.data.length,
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (buildContext, index) {
                            return PostItemWidget(
                              onLongPress: () {
                                ref
                                    .watch(
                                        editPostStateNotifierProvider.notifier)
                                    .updateState(
                                      data.data[index].content,
                                      data.data[index].bookId,
                                      data.data[index].imageUrl,
                                      data.data[index],
                                    );
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: const Icon(Icons.edit),
                                            title: const Text('Edit'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                context,
                                                RoutePaths.editPost,
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.delete),
                                            title: const Text('Delete'),
                                            onTap: () {
                                              ref
                                                  .watch(
                                                      deletePostStateNotifierProvider
                                                          .notifier)
                                                  .delelePost(context,
                                                      data.data[index].id);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              combinationPost: CombinationPost(
                                  id: data.data[index].id,
                                  content: data.data[index].content,
                                  createDate: data.data[index].createDate,
                                  nLikes: data.data[index].nLikes,
                                  nComments: data.data[index].nComments,
                                  user: UserPost(
                                    imageUrl: ref
                                        .watch(mainAppNotifierProvider)
                                        .user
                                        .image,
                                    username: ref
                                        .watch(mainAppNotifierProvider)
                                        .user
                                        .username,
                                    userId: ref
                                        .watch(mainAppNotifierProvider)
                                        .user
                                        .id,
                                  ),
                                  imageUrl: data.data[index].imageUrl,
                                  isDeleted: data.data[index].isDeleted),
                            );
                          }),
                    );
                  },
                  error: (error, stack) {
                    return Center(
                        child: Lottie.asset('assets/images/error.json'));
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
          ],
        ),
      ),
    );
  }
}
