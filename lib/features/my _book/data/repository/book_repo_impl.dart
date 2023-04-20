import 'dart:io';

import 'package:book_story/features/my%20_book/data/model/book_model.dart';
import 'package:book_story/features/my%20_book/domain/repository/book_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookRepoImpl extends BookRepo {
  @override
  Future<Either<Exception, String>> addBook(String name,
      String author,
      String description,
      String image,
      String language,
      String category,
      String createDate,
      String userId,) async {
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
        "category": category,
        "create_date": createDate,
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
            .doc(result.id).update({"image": r});
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
          .get();
      final books = result.docs
          .map((e) => BookModel.fromJsonIncludeId(e.data(), e.id))
          .toList();
      return right(books);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Exception, String>> uploadImage(String userId, String bookId,
      File image) async {
    try {
      final result = await FirebaseStorage.instance
          .ref()
          .child('users/$userId/books/')
          .putFile(image);
      final url = await result.ref.getDownloadURL();
      return right(url);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }
}
