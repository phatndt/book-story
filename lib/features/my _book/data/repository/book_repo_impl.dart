import 'dart:io';

import 'package:book_story/features/my%20_book/data/model/book_model.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookRepoImpl extends BookRepo {
  @override
  Future<Either<Exception, String>> addBook(
    String name,
    String author,
    String description,
    String image,
    String language,
    String releaseDate,
    String category,
    String createDate,
    String userId,
  ) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('books')
          .add({
        "name": name,
        "author": author,
        "description": description,
        "image": image,
        "language": language,
        "release_date": releaseDate,
        "category": category,
        "create_date": createDate,
        "read_file_path": "",
        "read_file_page": 0,
        "user_id": userId,
        "is_deleted": false,
      });
      final uploadResult = await uploadImage(userId, result.id, File(image));
      uploadResult.fold((l) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('books')
            .doc(result.id)
            .delete();
      }, (r) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('books')
            .doc(result.id)
            .update({"image": r});
      });
      return right(result.id);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<BookModel>>> getBooksByUser(
      String userId) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('books')
          .where("is_deleted", isEqualTo: false)
          .get();
      final books = result.docs
          .map((e) => BookModel.fromJsonIncludeId(e.data(), e.id))
          .toList();
      return right(books);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Exception, String>> uploadImage(
      String userId, String bookId, File image) async {
    try {
      final String fileName = image.path.split('/').last;
      final result = await FirebaseStorage.instance
          .ref()
          .child('users/$userId/books/$bookId/image/$fileName')
          .putFile(image);
      final url = await result.ref.getDownloadURL();
      return right(url);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, BookModel>> getBookDetail(
      String userId, String bookId) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('books')
          .doc(bookId)
          .get();
      if (result.data() != null) {
        final books = BookModel.fromJsonIncludeId(result.data()!, result.id);
        return right(books);
      } else {
        return left(Exception("Book not found"));
      }
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> updateReadFileOfBook(
      String userId, String bookId, String readFilePath) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('books')
          .doc(bookId)
          .update(
        {
          "read_file_path": readFilePath,
          "read_file_page": 0,
        },
      );
      return right(true);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Stream<Either<Exception, TaskSnapshot>>
      uploadReadFileBookToFirebaseStorageStream(
          String userId, String bookId, File readFile) {
    try {
      final String fileName = readFile.path.split('/').last;
      return FirebaseStorage.instance
          .ref()
          .child('users/$userId/books/$bookId/readFile/$fileName')
          .putFile(readFile)
          .snapshotEvents
          .map((event) {
        return right(event);
      });
    } catch (e) {
      return Stream.value(left(Exception(e.toString())));
    }
  }

  @override
  Future<Either<Exception, bool>> updateReadFilePageBook(
      String userId, String bookId, int page) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('books')
          .doc(bookId)
          .update({"read_file_page": page});
      return right(true);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteBook(
      String userId, String bookId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('books')
          .doc(bookId)
          .update({"is_deleted": true});
      return right(true);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }
}
