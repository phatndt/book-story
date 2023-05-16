import 'package:book_story/core/presentation/state.dart';
import 'package:book_story/features/my_book_shelf/domain/repository/book_shelf_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/book_shelf_model.dart';

class AddBookShelfState extends StateNotifier<UIState> {
  AddBookShelfState(this._bookShelfRepo) : super(UIInitialState());
  final BookShelfRepo _bookShelfRepo;

  addBookShelf(String name, String color) async {
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIErrorState(Exception("User is null. Please login again!"));
      return;
    }
    final bookShelfModel = BookShelfModel(
      '',
      name,
      List.empty(),
      color,
      DateTime.now().toString(),
      false,
    );
    state = const UILoadingState(true);
    final result = await _bookShelfRepo.addBookShelf(
        bookShelfModel, FirebaseAuth.instance.currentUser!.uid);
    state = const UILoadingState(false);
    result.fold((l) => state = UIErrorState(l), (r) => state = UISuccessState('add_book_shelf_successfully'.tr()));
  }
}
