import 'package:book_exchange/domain/entities/api_response.dart';
import 'package:book_exchange/domain/entities/user_post.dart';
import 'package:book_exchange/domain/use_cases/comment/create_comment_use_case.dart';
import 'package:book_exchange/domain/use_cases/comment/get_comment_by_post_use_case.dart';
import 'package:book_exchange/domain/use_cases/profile/get_user_use_case.dart';
import 'package:book_exchange/presentation/di/post_provider.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repos/comment_repo_impl.dart';
import '../../data/services/comment_service.dart';
import '../../domain/entities/combination_comment.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/comment_repo.dart';

final commentService = Provider<CommentService>(
  (ref) => CommentService(),
);

final commentRepo = Provider<CommentRepo>(
  (ref) => CommentRepoImpl(
    ref.watch(commentService),
  ),
);

final createCommentUseCase = Provider<CreateCommentUseCase>(
  (ref) => CreateCommentUseCase(
    ref.watch(commentRepo),
  ),
);

final getCommentByPostUseCase = Provider<GetCommentByPostUseCase>(
  (ref) => GetCommentByPostUseCase(
    ref.watch(commentRepo),
  ),
);

final getCommentByPostProvider = FutureProvider.family
    .autoDispose<List<CombinationComment>, MyParameter>(
        (ref, myParameter) async {
  final comments = await myParameter.getCommentByPostUseCase
      .getCommentByPost(myParameter.postId, BookAppModel.jwtToken);

  final listUserId = comments.data.map((e) => e.userId).toList();
  final listUserComment = (await ref
          .watch(getUserByUserid)
          .getUserByUserId(listUserId, BookAppModel.jwtToken))
      .data;

  final List<CombinationComment> combinationComment = [];
  for (var i = 0; i < comments.data.length; i++) {
    combinationComment.add(
      CombinationComment(
        id: comments.data[i].id,
        userPost: UserPost(
          imageUrl: listUserComment[i].imageUrl,
          username: listUserComment[i].username,
          userId: listUserComment[i].userId,
        ),
        postId: comments.data[i].postId,
        content: comments.data[i].content,
        createDate: comments.data[i].createDate,
        isDeleted: comments.data[i].isDeleted,
      ),
    );
  }

  return combinationComment;
});

final getUserFutureProvider =
    FutureProvider.family<ApiResponse<User>, GetUser>((ref, getUser) {
  return getUser.getUserUseCase.getUser(getUser.userId, BookAppModel.jwtToken);
});

class GetUser extends Equatable {
  const GetUser({
    required this.getUserUseCase,
    required this.userId,
  });

  final GetUserUseCase getUserUseCase;
  final String userId;

  @override
  List<Object> get props => [getUserUseCase, userId];
}

class MyParameter extends Equatable {
  const MyParameter({
    required this.getCommentByPostUseCase,
    required this.postId,
  });

  final GetCommentByPostUseCase getCommentByPostUseCase;
  final String postId;

  @override
  List<Object> get props => [getCommentByPostUseCase, postId];
}
