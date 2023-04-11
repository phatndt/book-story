import 'dart:developer';

import 'package:book_exchange/core/app_bar.dart';
import 'package:book_exchange/presentation/di/comment_component.dart';
import 'package:book_exchange/presentation/di/profile_component.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:book_exchange/presentation/views/widgets/post/post_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/colors/colors.dart';
import '../../../../domain/entities/combination_post.dart';
import '../../../di/post_provider.dart';
import '../../widgets/post/post_item.dart';

class PostDetail extends ConsumerWidget {
  const PostDetail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: ref.watch(postDetailNotifierProvider).loading,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(S.size.length_50Vertical),
            child: const AppBarImpl(title: "Post detail"),
          ),
          backgroundColor: S.colors.white,
          body: Column(
            children: [
              SizedBox(
                height: S.size.length_20Vertical,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: S.size.length_16,
                        ),
                        child: PostTitleWidget(
                          imagePath: ref
                              .watch(postDetailNotifierProvider)
                              .combinationPost
                              .user
                              .imageUrl,
                          username: ref
                              .watch(postDetailNotifierProvider)
                              .combinationPost
                              .user
                              .username,
                          createDate: DateFormat('dd/MM/yyyy, hh:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(int.parse(ref
                                  .watch(postDetailNotifierProvider)
                                  .combinationPost
                                  .createDate))),
                          onPressed: () {},
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: S.size.length_16,
                          vertical: S.size.length_20Vertical,
                        ),
                        child: Text(
                          ref
                              .watch(postDetailNotifierProvider)
                              .combinationPost
                              .content,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        height: 320.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(ref
                                .watch(postDetailNotifierProvider)
                                .combinationPost
                                .imageUrl),
                          ),
                        ),
                      ),
                      const PostSpacing(),
                      ref
                          .watch(getCommentByPostProvider(MyParameter(
                              getCommentByPostUseCase:
                                  ref.watch(getCommentByPostUseCase),
                              postId: ref
                                  .watch(postDetailNotifierProvider)
                                  .combinationPost
                                  .id)))
                          .when(
                            data: (data) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (buildContext, index) {
                                  return PostComment(
                                    imagePath: data[index].userPost.imageUrl,
                                    username: data[index].userPost.username,
                                    content: data[index].content,
                                    createDate:
                                        DateFormat('dd/MM/yyyy, hh:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(data[index].createDate),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            error: (error, stack) {
                              log(error.toString());
                              return Center(
                                  child:
                                      Lottie.asset('assets/images/error.json'));
                            },
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                          )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35.0),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 5,
                                color: Colors.grey)
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: S.size.length_10Vertical),
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.comment),
                              SizedBox(
                                width: S.size.length_10Vertical,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: ref
                                      .watch(postDetailNotifierProvider)
                                      .commentController,
                                  decoration: const InputDecoration(
                                      hintText: "Type comment here",
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.all(12.h),
                      decoration: BoxDecoration(
                        color: S.colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onTap: () {
                          ref
                              .watch(postDetailNotifierProvider.notifier)
                              .createComment(context);
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
