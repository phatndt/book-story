class Comment {
  final String id;
  final String userId;
  final String postId;
  final String content;
  final String createDate;
  final bool isDeleted;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.content,
    required this.createDate,
    required this.isDeleted,
  });
}
