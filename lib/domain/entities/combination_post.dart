import 'package:book_exchange/domain/entities/user_post.dart';

class CombinationPost {
  final String id;
  final String content;
  final String createDate;
  final int nLikes;
  final int nComments;
  final UserPost user;
  final String imageUrl;
  final bool isDeleted;

  CombinationPost({
    required this.id,
    required this.content,
    required this.createDate,
    required this.nLikes,
    required this.nComments,
    required this.user,
    required this.imageUrl,
    required this.isDeleted,
  });
}
