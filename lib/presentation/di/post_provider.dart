import 'package:book_exchange/data/repos/post_repo_impl.dart';
import 'package:book_exchange/data/services/post_service.dart';
import 'package:book_exchange/domain/repository/post_repo.dart';
import 'package:book_exchange/domain/use_cases/post/add_post_use_case.dart';
import 'package:book_exchange/domain/use_cases/post/add_post_use_case_impl.dart';
import 'package:book_exchange/domain/use_cases/post/delete_post_use_case.dart';
import 'package:book_exchange/domain/use_cases/post/get_all_post_use_case.dart';
import 'package:book_exchange/domain/use_cases/post/get_all_post_use_case_impl.dart';
import 'package:book_exchange/domain/use_cases/post/get_user_by_user_id.dart';
import 'package:book_exchange/domain/use_cases/post/get_user_by_user_id_impl.dart';
import 'package:book_exchange/domain/use_cases/post/update_post_use_case.dart';
import 'package:book_exchange/domain/use_cases/post/update_post_use_case_impl.dart';
import 'package:book_exchange/presentation/di/book_component.dart';
import 'package:book_exchange/presentation/di/comment_component.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:book_exchange/presentation/view_models/post/add_post_view_model.dart';
import 'package:book_exchange/presentation/view_models/post/delete_post_view_model.dart';
import 'package:book_exchange/presentation/view_models/post/post_detail_view_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/api_response.dart';
import '../../domain/entities/combination_post.dart';
import '../../domain/entities/post.dart';
import '../../domain/use_cases/post/delete_post_use_case_impl.dart';
import '../../domain/use_cases/post/get_my_post_use_case.dart';
import '../../domain/use_cases/post/get_my_post_use_case_impl.dart';
import '../view_models/post/edit_post_view_model.dart';

final postService = Provider<PostService>(
  (ref) => PostService(),
);

final postRepo = Provider<PostRepo>(
  (ref) => PostRepoImpl(
    ref.watch(postService),
  ),
);

final addPostUseCase = Provider<AddPostUseCase>(
  (ref) => AddPostUseCaseImpl(
    ref.watch(postRepo),
  ),
);

final addPostStateNotifierProvider =
    StateNotifierProvider.autoDispose<AddPostNotifier, AddPostState>(
  (ref) => AddPostNotifier(
    ref,
    ref.watch(addPostUseCase),
    ref.watch(uploadImageToCloudinaryUseCaseProvider),
    ref.watch(getListBookUseCaseProvider),
    ref.watch(getMyPostUseCase),
  ),
);

//get Post

final getAllPostPostUseCase = Provider<GetAllPostUseCase>(
  (ref) => GetAllPostUseCaseImpl(
    ref.watch(postRepo),
  ),
);

final getUserByUserid = Provider<GetUserByUserId>(
  (ref) => GetUserByUserIdImpl(
    ref.watch(postRepo),
  ),
);

final getAllPostFutureProvider =
    FutureProvider.family.autoDispose<List<CombinationPost>, GetAllPostUseCase>(
  ((ref, getAllPostPostUseCase) async {
    final list =
        (await getAllPostPostUseCase.getAllPost(BookAppModel.jwtToken)).data;
    final listUserId = list.map((e) => e.userId).toList();
    final listUserPost = (await ref
            .watch(getUserByUserid)
            .getUserByUserId(listUserId, BookAppModel.jwtToken))
        .data;

    List<CombinationPost> combinationPost = [];
    for (var i = 0; i < list.length; i++) {
      combinationPost.add(
        CombinationPost(
            id: list[i].id,
            content: list[i].content,
            createDate: list[i].createDate,
            nLikes: list[i].nLikes,
            nComments: list[i].nComments,
            user: listUserPost[i],
            imageUrl: list[i].imageUrl,
            isDeleted: list[i].isDeleted),
      );
    }
    return combinationPost;
  }),
);

final getMyPostUseCase = Provider<GetMyPostUseCase>(
  (ref) => GetMyPostUseCaseImpl(
    ref.watch(postRepo),
  ),
);

final getMyPostFutureProvider = FutureProvider.family
    .autoDispose<ApiResponse<List<Post>>, GetMyPostUseCase>(
  ((ref, getMyPostPostUseCase) {
    return getMyPostPostUseCase.getMyPost(BookAppModel.jwtToken);
  }),
);

final deletePostUseCase = Provider<DeletePostUseCase>(
  (ref) => DeletePostUseCaseImpl(
    ref.watch(postRepo),
  ),
);

final deletePostStateNotifierProvider =
    StateNotifierProvider<DeletePostStateNotifier, int>(
  (ref) => DeletePostStateNotifier(ref, ref.watch(deletePostUseCase)),
);

final updatePostUseCase = Provider<UpdatePostUseCase>(
  (ref) => UpdatePostUseCaseImpl(
    ref.watch(postRepo),
  ),
);

final editPostStateNotifierProvider =
    StateNotifierProvider.autoDispose<EditPostStateNotifier, EditPostState>(
        (ref) => EditPostStateNotifier(
              ref,
              ref.watch(updatePostUseCase),
              ref.watch(uploadImageToCloudinaryUseCaseProvider),
              ref.watch(getListBookUseCaseProvider),
              ref.watch(getMyPostUseCase),
            ));

final postDetailNotifierProvider =
    StateNotifierProvider<PostDetailNotifier, PostDetailState>(
  (ref) => PostDetailNotifier(ref, ref.watch(createCommentUseCase), ref.watch(getCommentByPostUseCase)),
);



