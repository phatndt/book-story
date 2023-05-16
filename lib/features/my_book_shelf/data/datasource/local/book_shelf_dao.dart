
import 'package:book_story/core/const.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../model/book_shelf_model.dart';

class BookShelfDao {
  Future<List<BookShelfModel>> getBookShelfList() async {
    final db = Hive.box<BookShelfModel>(bookShelf);
    return db.values.toList();
  }

  Future<List<int>> saveBookShelfListModel(List<BookShelfModel> bookShelfModel) async {
    final db = Hive.box<BookShelfModel>(bookShelf);
    await db.clear();
    final result = await db.addAll(bookShelfModel);
    return result.toList();
  }
}