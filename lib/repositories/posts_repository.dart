import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unishop/dao/dao.dart';
import 'package:unishop/models/degree_relations.dart';
import 'package:unishop/models/product.dart';

class PostsRepository {
  static Future<List<Product>> getListProducts() async{
    Response data = await daoGetProducts();
    final jsonData =  json.decode(data.body);
    if (data.statusCode == 200) {
      final List<dynamic> postList = jsonData['post'];
      final List<Product> products = postList.map((item) {
        final imageUrls = (item['urlsImages'] as String).split(';');
        return Product(
          degree: item['degree'],
          description: item['description'],
          isNew: item['new'],
          price: double.parse(item['price'].toString()
                .substring(1)
                .replaceAll('.', '')
                .replaceAll(',', '')),
          isRecycled: item['recycled'],
          subject: item['subject'],
          image: imageUrls,
          title: item['name'],
        );
      }).toList();
      return products;
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  static Future<List<Product>> getRecommendations() async {
    List<Product> products = await getListProducts();
    final recommendedProducts = <Product>[];
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

  static Product createPost(
      String enteredDegree,
      String enteredDescription,
      String enteredTitle,
      bool enteredIsNew,
      String enteredPrice,
      bool enteredIsRecycled,
      String enteredSubject,
      String image,
      String userId) {
    daoCreatePost(
      enteredDegree,
      enteredDescription,
      enteredTitle,
      enteredIsNew,
      enteredPrice,
      enteredIsRecycled,
      enteredSubject,
      image,
      userId);
    List<String> images = [image];
    Product createdProduct = Product(
        title: enteredTitle,
        description: enteredDescription,
        price: double.tryParse(enteredPrice)!,
        isNew: enteredIsNew,
        isRecycled: enteredIsRecycled,
        degree: enteredDegree,
        subject: enteredSubject,
        image: images,
      );
    return createdProduct;
  }

  static Future<List<Product>> loadProducts () async {
    final prefs = await SharedPreferences.getInstance();
    final queryParameters = {'id': prefs.getString('user_id')};
    final Map<String, dynamic> listData = await daoLoadProducts(queryParameters);
    final List<Product> loadedProducts = [];
    for (final items in listData.entries) {
      for (final item in items.value) {
        loadedProducts.add(
          Product(
            title: item['name'],
            description: item['description'],
            price: double.parse(item['price']
                .toString()
                .substring(1)
                .replaceAll('.', '')
                .replaceAll(',', '')),
            isNew: item['new'],
            isRecycled: item['recycled'],
            degree: item['degree'],
            subject: item['subject'],
            image: [item['urlsImages']],
          ),
        );
      }
    }
    return loadedProducts;
  }
}

