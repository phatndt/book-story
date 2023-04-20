class BookModel {
  final String id;
  final String name;
  final String author;
  final String description;
  final String image;
  final String category;
  final String language;
  final String userId;
  final String createDate;
  final bool isDeleted;

  BookModel(
      this.id,
      this.name,
      this.author,
      this.description,
      this.image,
      this.category,
      this.language,
      this.userId,
      this.createDate,
      this.isDeleted,
      );
  toMap() {
    return {
      'id': id,
      'name': name,
      'author': author,
      'description': description,
      'image': image,
      'category': category,
      'language': language,
      'user_id': userId,
      'create_date': createDate,
      'is_deleted': isDeleted,
    };
  }
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      json['id'],
      json['name'],
      json['author'],
      json['description'],
      json['image'],
      json['category'],
      json['language'],
      json['user_id'],
      json['create_date'],
      json['is_deleted'],
    );
  }

  factory BookModel.fromJsonIncludeId(Map<String, dynamic> json, String userId) {
    return BookModel(
      userId,
      json['name'],
      json['author'],
      json['description'],
      json['image'],
      json['category'],
      json['language'],
      json['user_id'],
      json['create_date'],
      json['is_deleted'],
    );
  }
}