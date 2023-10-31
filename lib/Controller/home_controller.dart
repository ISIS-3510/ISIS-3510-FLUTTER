import 'package:unishop/Model/Repository/posts_repository.dart';
import 'package:unishop/Model/DTO/product_dto.dart';

class HomeController {
  Future<List<ProductDTO>> getListProducts() async {
    return PostsRepository.getListProducts();
  }
}
