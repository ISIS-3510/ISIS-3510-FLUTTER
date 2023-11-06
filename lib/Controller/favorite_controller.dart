import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/Model/Repository/posts_repository.dart';

class FavoriteController {
  Future<void> addFavorite(postId) async {
    return PostsRepository.addFavorite(postId);
  }

  Future<void> deleteFavorite(postId) async {
    return PostsRepository.deleteFavorite(postId);
  }

  Future<List<ProductDTO>> getFavorites() async {
    return PostsRepository.getFavorites();
  }
}