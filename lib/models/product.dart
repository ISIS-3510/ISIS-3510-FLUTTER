class Product {
  const Product({
    required this.title,
    required this.description,
    required this.price,
    required this.isNew,
    required this.isRecycled,
    required this.degree,
    required this.subject,
    required this.image,
  });

  final String title;
  final String description;
  final double price;
  final bool isNew;
  final bool isRecycled;
  final String degree;
  final String subject;
  final String image;
}
