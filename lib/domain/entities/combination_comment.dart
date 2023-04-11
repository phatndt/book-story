import 'package:book_exchange/domain/entities/user_post.dart';

class CombinationComment {
  final String id;
  final UserPost userPost;
  final String postId;
  final String content;
  final String createDate;
  final bool isDeleted;

  CombinationComment({
    required this.id,
    required this.userPost,
    required this.postId,
    required this.content,
    required this.createDate,
    required this.isDeleted,
  });
}
