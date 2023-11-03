import 'package:decimal/decimal.dart';

class ProductDTO{
  const ProductDTO({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.isNew,
    required this.isRecycled,
    required this.degree,
    required this.subject,
    required this.image,
    this.user,
  });

  final String? id;
  final String title;
  final String description;
  final Decimal price;
  final bool isNew;
  final bool isRecycled;
  final String degree;
  final String subject;
  final List<String> image;
  final Map<String, dynamic>? user;

  String getUsername() {
    if(user == null) {
      return "Anónimo";
    }
    return user!['username'];
  }
}
