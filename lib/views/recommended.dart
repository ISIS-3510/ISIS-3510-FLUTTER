import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unishop/models/degree_relations.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Product {
  final String id;
  final String degree;
  final String description;
  final bool isNew;
  final String price;
  final bool recycled;
  final String subject;
  final List<String> imageUrls;
  final String date;
  final String name;
  final String userName;

  Product({
    required this.id,
    required this.degree,
    required this.description,
    required this.isNew,
    required this.price,
    required this.recycled,
    required this.subject,
    required this.imageUrls,
    required this.date,
    required this.name,
    required this.userName,
  });
}

class RecommendedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
         appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            margin:
                EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0), // Add top margin here
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                //Use SvgPicture.asset to display the SVG icon
                Padding(
                  padding: EdgeInsets.only(left: 25.0), // Add left padding here
                  child: SvgPicture.asset(
                    'assets/Favorite.svg', // Replace with your SVG file path
                    width: 12, // Set the width of the SVG icon
                    height: 12, // Set the height of the SVG icon
                    colorFilter: ColorFilter.mode(Colors.black,
                        BlendMode.srcIn), // Set the color of the SVG icon
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Products',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        body:
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<Product>>(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return Text('No se encontraron datos');
                } else {
                  final products = snapshot.data!;
                  return ProductCatalog(products: products);
                }
              },
            ),
          )
         
      ),
    );
  }

  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('https://creative-mole-46.hasura.app/api/rest/post/all');
    final headers = {
      'content-type': 'application/json',
      'x-hasura-admin-secret': 'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> postList = jsonData['post'];

      final List<Product> products = postList.map((item) {
        final imageUrls = (item['urlsImages'] as String).split(';');
        return Product(
          id: item['id'],
          degree: item['degree'],
          description: item['description'],
          isNew: item['new'],
          price: item['price'],
          recycled: item['recycled'],
          subject: item['subject'],
          imageUrls: imageUrls,
          date: item['date'],
          name: item['name'],
          userName: item['user']['username'],
        );
      }).toList();
      final prefs = await SharedPreferences.getInstance();
      final recommendedProducts = <Product>[];
      for (final product in products) {
        if (product.degree == prefs.getString('user_degree') || DegreeRelations().degreeRelations[prefs.getString('user_degree')]!.contains(product.degree) ) {
          recommendedProducts.add(product);
        }
      }
      return recommendedProducts;
    } else {
      throw Exception('Error al cargar los productos');
    }
  }
}

class ProductCatalog extends StatelessWidget {
  final List<Product> products;

  ProductCatalog({required this.products});
  bool _isValidImageUrl(String imageUrl) {
    return imageUrl.startsWith('h'.trim());
  }


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dos productos por fila
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        final product = products[index];
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Ajusta el radio según tus preferencias
          ),
            child: SizedBox(
              height: 00,
              child: Column(
                children: [
                  if (_isValidImageUrl(product.imageUrls.first))
                    Image.network(
                      product.imageUrls.first,
                      fit: BoxFit.cover,
                      height: 100,
                      width: double.infinity,
                    )
                  else
                    Image.asset(
                      'assets/NotFound.png', // Replace with the path to your placeholder image
                      fit: BoxFit.cover,
                      height: 100,
                      width: double.infinity,
                    ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                  //   child: Text(
                  //     product.price,
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
        );
      },
    );
  }
}
