import 'package:book_exchange/domain/use_cases/post/delete_post_use_case.dart';
import 'package:book_exchange/presentation/di/post_provider.dart';
import 'package:book_exchange/presentation/models/book_app_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/extension/function_extension.dart';

class DeletePostStateNotifier extends StateNotifier<int> {
  DeletePostStateNotifier(
    this.ref,
    this._deletePostUseCase,
  ) : super(0);

  final Ref ref;
  final DeletePostUseCase _deletePostUseCase;

  delelePost(BuildContext context, String postId) {
    _deletePostUseCase.deletePost(BookAppModel.jwtToken, postId).then(
      (value) {
        if (value.data.length == 24) {
          showTopSnackBar(
            context,
            const CustomSnackBar.success(
              message: "Delete post successfully",
            ),
            displayDuration: const Duration(seconds: 1),
          );
          Navigator.pop(context);
          ref.refresh(getMyPostFutureProvider(ref.watch(getMyPostUseCase)));
        } else {
          showTopSnackBar(
            context,
            const CustomSnackBar.error(
              message: "Something wrong (Delete faiiled)",
            ),
            displayDuration: const Duration(seconds: 1),
          );
        }
      },
    ).onError((error, stackTrace) {
      catchOnError(context, onError);
    });
  }
}
