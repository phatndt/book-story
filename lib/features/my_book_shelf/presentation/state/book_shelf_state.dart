import 'package:book_story/features/my_book_shelf/domain/repository/book_shelf_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';

class BookShelfState extends StateNotifier<UIState> {
  BookShelfState(this.ref, this._bookRepo) : super(UIInitialState());

  final Ref ref;
  final BookShelfRepo _bookRepo;

  Future<void> getBookShelfList() async {
    if (FirebaseAuth.instance.currentUser == null) {
      state = UIErrorState(Exception("User is null. Please login again!"));
      return;
    }
    state = const UILoadingState(true);
    final result = await _bookRepo.getBookShelfList(FirebaseAuth.instance.currentUser!.uid);
    state = const UILoadingState(false);
    result.fold((l) {
      state = UIErrorState(l);
    }, (r) {
      state = UISuccessState(r.map((e) => e.toEntity()).toList());
    });
  }
}
