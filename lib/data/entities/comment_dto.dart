class CommentDTO {
  final String id;
  final String userId;
  final String postId;
  final String content;
  final String createDate;
  final bool isDeleted;

  CommentDTO({
    required this.id,
    required this.userId,
    required this.postId,
    required this.content,
    required this.createDate,
    required this.isDeleted,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id ': id,
      'userId': userId,
      'postId': postId,
      'content': content,
      'createDate': createDate,
      'isDeleted': isDeleted,
    };
  }

  factory CommentDTO.fromMap(Map<dynamic, dynamic> map) {
    return CommentDTO(
      id: map['id'],
      userId: map['userId'],
      postId: map['postId'],
      content: map['content'],
      createDate: map['createDate'],
      isDeleted: map['deleted'],
    );
  }
}
