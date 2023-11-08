import 'package:unishop/Model/Repository/posts_repository.dart';
import 'package:unishop/Model/DTO/product_dto.dart';

class NewPostController {
  Future<ProductDTO> createPost(
      String enteredDegree,
      String enteredDescription,
      String enteredTitle,
      bool enteredIsNew,
      String enteredPrice,
      bool enteredIsRecycled,
      String enteredSubject,
      String image,
      String userId) async{
    return await PostsRepository.createPost(
        enteredDegree,
        enteredDescription,
        enteredTitle,
        enteredIsNew,
        enteredPrice,
        enteredIsRecycled,
        enteredSubject,
        image,
        userId);
  }
}
