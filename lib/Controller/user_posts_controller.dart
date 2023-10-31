import 'package:unishop/Model/Repository/posts_repository.dart';
import 'package:unishop/Model/DTO/product_dto.dart';

class UserPostController {
  Future<List<ProductDTO>> loadProducts() async {
    return await PostsRepository.loadProducts();
  }
}
