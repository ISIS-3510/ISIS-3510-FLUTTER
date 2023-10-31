import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unishop/Model/DAO/dao.dart';
import 'package:unishop/Model/degree_relations.dart';
import 'package:unishop/Model/DTO/product_dto.dart';

class PostsRepository {
  static Future<List<ProductDTO>> getListProducts() async {
    Response data = await daoGetProducts();
    final jsonData = json.decode(data.body);
    if (data.statusCode == 200) {
      final List<dynamic> postList = jsonData['post'];
      final List<ProductDTO> products = postList.map((item) {
        final imageUrls = (item['urlsImages'] as String).split(';');
        return ProductDTO(
          degree: item['degree'],
          description: item['description'],
          isNew: item['new'],
          price: Decimal.parse(item['price']
              .toString()
              .substring(1)
              .replaceAll(',', '')),
          isRecycled: item['recycled'],
          subject: item['subject'],
          image: imageUrls,
          title: item['name'],
          user: item['user'],
        );
      }).toList();
      return products;
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  static Future<List<ProductDTO>> getRecommendations() async {
    List<ProductDTO> products = await getListProducts();
    final recommendedProducts = <ProductDTO>[];
    final prefs = await SharedPreferences.getInstance();
    for (final product in products) {
      if (product.degree == prefs.getString('user_degree') ||
          DegreeRelations()
              .degreeRelations[prefs.getString('user_degree')]!
              .contains(product.degree)) {
        recommendedProducts.add(product);
      }
    }
    return recommendedProducts;
  }

  static Future<List<ProductDTO>> getBargains() async {
    List<ProductDTO> products = await getListProducts();
    List<ProductDTO> bargainProducts = <ProductDTO>[];
    for (final product in products) {
        bargainProducts.add(product);
        bargainProducts.sort((a, b) => a.price.compareTo(b.price));
    }
    return bargainProducts;
  }

  static ProductDTO createPost(
      String enteredDegree,
      String enteredDescription,
      String enteredTitle,
      bool enteredIsNew,
      String enteredPrice,
      bool enteredIsRecycled,
      String enteredSubject,
      String image,
      String userId) {
    daoCreatePost(enteredDegree, enteredDescription, enteredTitle, enteredIsNew,
        enteredPrice, enteredIsRecycled, enteredSubject, image, userId);
    List<String> images = [image];
    ProductDTO createdProduct = ProductDTO(
      title: enteredTitle,
      description: enteredDescription,
      price: Decimal.tryParse(enteredPrice)!,
      isNew: enteredIsNew,
      isRecycled: enteredIsRecycled,
      degree: enteredDegree,
      subject: enteredSubject,
      image: images
    );
    return createdProduct;
  }

  static Future<List<ProductDTO>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final queryParameters = {'id': prefs.getString('user_id')};
    final Map<String, dynamic> listData =
        await daoLoadProducts(queryParameters);
    final List<ProductDTO> loadedProducts = [];
    for (final items in listData.entries) {
      for (final item in items.value) {
        loadedProducts.add(
          ProductDTO(
            title: item['name'],
            description: item['description'],
            price: Decimal.parse(item['price']
                .toString()
                .substring(1)
                .replaceAll(',', ''),
                ),
            isNew: item['new'],
            isRecycled: item['recycled'],
            degree: item['degree'],
            subject: item['subject'],
            image: [item['urlsImages']],
            user: item['user'],
          ),
        );
      }
    }
    return loadedProducts;
  }
}
