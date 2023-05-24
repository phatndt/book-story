import 'package:book_story/features/my_book_shelf/domain/repository/book_shelf_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';
import '../../../my _book/domain/entity/book.dart';
import '../../../my _book/domain/repository/book_repo.dart';

class AddBookToShelfStateNotifier extends StateNotifier<UIState> {
  AddBookToShelfStateNotifier(this.ref, this._bookRepo, this._bookShelfRepo)
      : super(UIInitialState());

  final Ref ref;
  final BookRepo _bookRepo;
  final BookShelfRepo _bookShelfRepo;

  getBook(List<String> bookIdList) {
    state = const UILoadingState(true);
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIErrorState(Exception("User is null. Please login again!"));
      return;
    }
    _bookRepo.getBooksByUser(FirebaseAuth.instance.currentUser!.uid).then(
      (value) {
        state = const UILoadingState(false);
        value.fold(
          (l) {
            state = UIErrorState(l);
          },
          (r) {
            final result =
                r.where((element) => !bookIdList.contains(element.id));
            state =
                UISuccessState(result.map((e) => Book.fromModel(e)).toList());
          },
        );
      },
    );
  }

  addBookToShelf(String bookShelfId, List<String> bookIds) async {
    state = const UILoadingState(true);
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIErrorState(Exception('user_is_null_login_again'.tr()));
      return;
    }
    final result = await _bookShelfRepo.updateBooks(
        FirebaseAuth.instance.currentUser!.uid, bookShelfId, bookIds);
    state = const UILoadingState(false);
    result.fold(
        (l) => state = UIErrorState(l), (r) => state = const UIUpdateBooksOfShelfSuccessState());
  }
}

class UIUpdateBooksOfShelfSuccessState extends UIState {
    const UIUpdateBooksOfShelfSuccessState(): super();
}
