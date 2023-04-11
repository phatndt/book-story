import 'package:book_exchange/domain/use_cases/book/get_list_book_by_id_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/book.dart';
import '../models/book_app_model.dart';

class CollectionSetting {
  final bool isPressed;
  List<Book> listBook;
  
  CollectionSetting({
    required this.isPressed,
    required this.listBook,
  });

  CollectionSetting copy({
    bool? isPressed,
    List<Book>? listBook,
  }) =>
      CollectionSetting(
        isPressed: isPressed ?? false,
        listBook: listBook ?? this.listBook,
      );
}

class CollectionSettingNotifier extends StateNotifier<CollectionSetting> {
  CollectionSettingNotifier(this.ref)
      : super(
          CollectionSetting(
            isPressed: false,
            listBook: [],
          ),
        );

  final Ref ref;
}

final getListBookProvider = FutureProvider.autoDispose.family<List<Book>, GetListBookUseCase>(
  (ref, getListBookUseCase) async =>
      (await getListBookUseCase.getListBook(BookAppModel.jwtToken)).data,
);
