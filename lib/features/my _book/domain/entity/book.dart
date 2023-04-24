import '../../data/model/book_model.dart';

class Book {
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

  Book(
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

  factory Book.fromModel(BookModel bookModel) {
    return Book(
        bookModel.id,
        bookModel.name,
        bookModel.author,
        bookModel.description,
        bookModel.image,
        bookModel.category,
        bookModel.language,
        bookModel.releaseDate,
        bookModel.userId,
        bookModel.readFile,
        bookModel.readFilePage,
        bookModel.createDate,
        bookModel.isDeleted);
  }
}
