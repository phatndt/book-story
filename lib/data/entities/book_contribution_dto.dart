class ContributionBookDTO {
  final String id;
  final String name;
  final String author;
  final String description;
  final String imageUrl;
  final String normalBarcode;
  final String isbnBarcode;
  final bool deleted;
  final bool verified;

  ContributionBookDTO({
    required this.id,
    required this.name,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.normalBarcode,
    required this.isbnBarcode,
    required this.deleted,
    required this.verified,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'id ': id,
      'name': name,
      'author': author,
      'description': description,
      'imageUrl': imageUrl,
      "normalBarcode": normalBarcode,
      "isbnBarcode": isbnBarcode,
      'verified': verified,
      'deleted': deleted,
    };
  }

  factory ContributionBookDTO.fromMap(Map<dynamic, dynamic> map) {
    return ContributionBookDTO(
      id: map['id'],
      name: map['name'],
      author: map['author'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      normalBarcode: map['normalBarcode'],
      isbnBarcode: map['isbnBarcode'],
      verified: map['verified'],
      deleted: map['deleted'],
    );
  }
}
