class Post {
  final String id;
  final String content;
  final String createDate;
  final int nLikes;
  final int nComments;
  final String userId;
  final String imageUrl;
  final String bookId;
  final bool isDeleted;

  Post({
    required this.id,
    required this.content,
    required this.createDate,
    required this.nLikes,
    required this.nComments,
    required this.userId,
    required this.imageUrl,
    required this.bookId,
    required this.isDeleted,
  });
}
