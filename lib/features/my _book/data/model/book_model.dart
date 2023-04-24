class  BookModel {
  final String id;
  final String name;
  final String author;
  final String description;
  final String image;
  final String category;
  final String language;
  final String releaseDate;
  final String userId;
  final String readFile;
  final int readFilePage;
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
      this.releaseDate,
      this.userId,
      this.readFile,
      this.readFilePage,
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
      'release_date': releaseDate,
      'user_id': userId,
      'read_file_path': readFile,
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
      json['release_date'],
      json['user_id'],
      json['read_file_path'],
      json['read_file_page'],
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
      json['release_date'],
      json['user_id'],
      json['read_file_path'],
      json['read_file_page'],
      json['create_date'],
      json['is_deleted'],
    );
  }
}