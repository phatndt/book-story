import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/state.dart';
import '../../domain/repository/book_shelf_repo.dart';

class SearchBookShelfState extends StateNotifier<UIState> {
  SearchBookShelfState(this._bookShelfRepo) : super(UIInitialState());
  final BookShelfRepo _bookShelfRepo;

  getBookShelfFromLocal() async {
    state = const UILoadingState(true);
    final result = await _bookShelfRepo.getBookShelfListFromLocal();
    state = const UILoadingState(false);
    result.fold((l) => state  = UIErrorState(l), (r) => state = UISuccessState(r.map((e) => e.toEntity()).toList()));
  }
}