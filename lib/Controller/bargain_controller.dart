import 'package:unishop/Model/Repository/posts_repository.dart';
import 'package:unishop/Model/DTO/product_dto.dart';

class BargainController {
  Future<List<ProductDTO>> getBargains() async {
    return PostsRepository.getBargains();
  }
}
