import 'package:book_story/features/my_book_shelf/data/datasource/local/book_shelf_dao.dart';
import 'package:book_story/features/my_book_shelf/domain/repository/book_shelf_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../model/book_shelf_model.dart';

class BookShelfRepoImpl extends BookShelfRepo {
  final BookShelfDao bookShelfDao;

  BookShelfRepoImpl(this.bookShelfDao);

  @override
  Future<Either<Exception, List<BookShelfModel>>> getBookShelfList(
      String userId) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('book_shelf')
          .where('is_deleted', isEqualTo: false)
          .get();
      if (result.docs.isNotEmpty) {
        final bookShelfList = result.docs
            .map((e) => BookShelfModel.fromJson(e.data(), e.id))
            .toList();
        await bookShelfDao.saveBookShelfListModel(bookShelfList);
        return right(bookShelfList);
      } else {
        return right([]);
      }
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, String>> addBookShelf(
      BookShelfModel bookShelfModel, String userId) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('book_shelf')
          .add(bookShelfModel.toJsonNoId());
      return right(result.id);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<BookShelfModel>>>
      getBookShelfListFromLocal() async {
    try {
      final result = await bookShelfDao.getBookShelfList();
      return right(result);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, BookShelfModel>> getBookShelfById(
      String userId, String bookShelfId) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('book_shelf')
          .doc(bookShelfId)
          .get();
      if (result.exists && result.data() != null) {
        final bookShelf = BookShelfModel.fromJson(result.data()!, result.id);
        return right(bookShelf);
      } else {
        return left(Exception('book_shelf_not_found'.tr()));
      }
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteBookShelf(
      String userId, String bookShelfId) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('book_shelf')
          .doc(bookShelfId)
          .update({"is_deleted": true});
      return right(true);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> updateBookShelf(
    String userId,
    String bookShelfId,
    String name,
    String color,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('book_shelf')
          .doc(bookShelfId)
          .update({
        "name": name,
        "color": color,
      });
      return right(true);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> updateBooks(String userId, String bookShelfId, List<String> bookIds) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('book_shelf')
          .doc(bookShelfId)
          .update({
        "books_list": bookIds,
      });
      return right(true);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteBookFromShelf(String userId, String bookShelfId, List<String> bookIds) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('book_shelf')
          .doc(bookShelfId)
          .update({
        "books_list": bookIds,
      });
      return right(true);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }
}
