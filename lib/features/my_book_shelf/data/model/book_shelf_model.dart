import '../../domain/entity/book_shelf.dart';

class BookShelfModel {
  final String id;
  final String name;
  final List<String> booksList;
  final String color;
  final String createDate;
  final bool isDelete;

  BookShelfModel(
    this.id,
    this.name,
    this.booksList,
    this.color,
    this.createDate,
    this.isDelete,
  );

  factory BookShelfModel.fromJson(Map<String, dynamic> json, String id) {
    final list = json['books_list'] as List;
    return BookShelfModel(
      id,
      json['name'],
      list.map((e) => e.toString()).toList(),
      json['color'],
      json['create_date'],
      json['is_deleted'],
    );
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'books_list': booksList,
      'color': color,
      'create_date': createDate,
      'is_deleted': isDelete,
    };
  }

  toJsonNoId() {
    return {
      'name': name,
      'books_list': booksList,
      'color': color,
      'create_date': createDate,
      'is_deleted': isDelete,
    };
  }

  BookShelf toEntity() {
    return BookShelf(
      id,
      name,
      booksList,
      color,
      createDate,
      isDelete,
    );
  }
}
