import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unishop/models/product.dart';
import 'package:unishop/repositories/posts_repository.dart';

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
    return PostsRepository.getRecommendations();
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
                  if (_isValidImageUrl(product.image.first))
                    Image.network(
                      product.image.first,
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
