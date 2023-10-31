import 'package:unishop/Model/Repository/posts_repository.dart';
import 'package:unishop/Model/DTO/product_dto.dart';

class RecomendedController {
  Future<List<ProductDTO>> getRecommendations() async {
    return PostsRepository.getRecommendations();
  }
}
