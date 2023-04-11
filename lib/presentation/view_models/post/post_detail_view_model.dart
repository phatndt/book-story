import 'package:book_exchange/domain/entities/combination_post.dart';
import 'package:book_exchange/domain/entities/comment.dart';
import 'package:book_exchange/domain/entities/user_post.dart';
import 'package:book_exchange/domain/use_cases/comment/create_comment_use_case.dart';
import 'package:book_exchange/domain/use_cases/comment/get_comment_by_post_use_case.dart';
import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:book_exchange/presentation/di/comment_component.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/extension/function_extension.dart';

class PostDetailState {
  final CombinationPost combinationPost;
  final TextEditingController commentController;
  List<Comment>? comments;
  bool loading;
  PostDetailState({
    required this.combinationPost,
    required this.commentController,
    required this.comments,
    this.loading = false,
  });

  PostDetailState copy({
    CombinationPost? combinationPost,
    TextEditingController? commentController,
    List<Comment>? comments,
    bool? loading,
  }) =>
      PostDetailState(
        combinationPost: combinationPost ?? this.combinationPost,
        commentController: commentController ?? this.commentController,
        comments: comments ?? this.comments,
        loading: loading ?? this.loading,
      );
}

class PostDetailNotifier extends StateNotifier<PostDetailState> {
  PostDetailNotifier(
    this.ref,
    this._createCommentUseCase,
    this._getCommentByPostUseCase,
  ) : super(
          PostDetailState(
              combinationPost: CombinationPost(
                  id: "",
                  content: "",
                  createDate: "",
                  nLikes: 0,
                  nComments: 0,
                  user: UserPost(imageUrl: "", username: "", userId: ""),
                  imageUrl: "",
                  isDeleted: false),
              commentController: TextEditingController(),
              comments: null),
        );
  final Ref ref;
  final CreateCommentUseCase _createCommentUseCase;
  final GetCommentByPostUseCase _getCommentByPostUseCase;

  setCombinationPost(CombinationPost combinationPost) {
    final newState = state.copy(combinationPost: combinationPost);
    state = newState;
    getCommentByPost();
  }

  setComments(List<Comment>? comments) {
    final newState = state.copy(comments: comments);
    state = newState;
  }

  setLoading() {
    final newState = state.copy(loading: !state.loading);
    state = newState;
  }

  void createComment(BuildContext context) {
    if (state.commentController.text.isEmpty) {
      showTopSnackBar(
        context,
        const CustomSnackBar.info(
          message: "Content is empty.",
        ),
        displayDuration: const Duration(seconds: 1),
      );
      return;
    }
    setLoading();
    final comment = Comment(
        id: "",
        userId: ref.watch(mainAppNotifierProvider).user.id,
        postId: state.combinationPost.id,
        content: state.commentController.text,
        createDate: DateTime.now().millisecondsSinceEpoch.toString(),
        isDeleted: false);
    _createCommentUseCase
        .createPost(comment, BookAppModel.jwtToken)
        .then((value) {
      setLoading();
      state.commentController.clear();
      ref.refresh(
        getCommentByPostProvider(
          MyParameter(
              getCommentByPostUseCase: ref.watch(getCommentByPostUseCase),
              postId: state.combinationPost.id),
        ),
      );
    }).catchError((onError) {
      setLoading();
      catchOnError(context, onError);
    });
  }

  void getCommentByPost() {
    _getCommentByPostUseCase
        .getCommentByPost(state.combinationPost.id, BookAppModel.jwtToken)
        .then((value) {
      setComments(value.data);
    }).catchError((onError) {
      setComments(null);
    });
  }
}
