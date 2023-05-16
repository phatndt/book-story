import '../../data/model/book_shelf_model.dart';

class BookShelf {
  final String id;
  final String name;
  final List<String> booksList;
  final String color;
  final String createDate;
  final bool isDelete;

  BookShelf(
      this.id,
      this.name,
      this.booksList,
      this.color,
      this.createDate,
      this.isDelete,
      );

  factory BookShelf.fromModel(BookShelfModel bookShelfModel) {
    return BookShelf(
      bookShelfModel.id,
      bookShelfModel.name,
      bookShelfModel.booksList,
      bookShelfModel.color,
      bookShelfModel.createDate,
      bookShelfModel.isDelete,
    );
  }
}

