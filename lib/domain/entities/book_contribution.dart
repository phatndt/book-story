class ContributionBook {
  final String id;
  final String name;
  final String author;
  final String description;
  final String imageUrl;

  final bool delete;
  final bool verified;

  final String normalBarcode;
  final String isbnBarcode;

  ContributionBook({
    required this.id,
    required this.name,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.delete,
    required this.verified,
    required this.normalBarcode,
    required this.isbnBarcode,
  });
}
