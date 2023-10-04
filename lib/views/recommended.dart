import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Recomendados'),
          backgroundColor: Color(0xFFFFC600),
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

      return products;
    } else {
      throw Exception('Error al cargar los productos');
    }
  }
}

class ProductCatalog extends StatelessWidget {
  final List<Product> products;

  ProductCatalog({required this.products});

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
                  Image.network(
                    product.imageUrls.first,
                    fit: BoxFit.cover,
                    height: 100,
                    width: double.infinity,
                  ),
                  ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.description,
                      maxLines: 1, // Limita a dos líneas de texto
                      overflow: TextOverflow.ellipsis,),
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
