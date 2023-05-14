class BookShelfModel {
  final String id;
  final String name;
  final String booksList;
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
    return BookShelfModel(
      id,
      json['name'],
      json['books_list'],
      json['color'],
      json['create_date'],
      json['is_delete'],
    );
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'books_list': booksList,
      'color': color,
      'create_date': createDate,
      'is_delete': isDelete,
    };
  }

  toJsonNoId() {
    return {
      'name': name,
      'books_list': booksList,
      'color': color,
      'create_date': createDate,
      'is_delete': isDelete,
    };
  }
}
