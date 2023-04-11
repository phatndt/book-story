class Book {
  final String id;
  final String name;
  final String author;
  final String description;
  final double rate;
  final String imageURL;
  final String userId;
  final bool delete;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.description,
    required this.rate,
    required this.imageURL,
    required this.userId,
    required this.delete,
  });

  @override
  String toString() => "$name - $author";

  @override
  operator ==(o) => o is Book && o.id == id;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ author.hashCode;
}
