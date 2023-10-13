import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unishop/models/product.dart';
import 'package:unishop/repositories/posts_repository.dart';

class RecommendedView extends StatefulWidget {
  @override
  _RecommendedViewState createState() => _RecommendedViewState();
}

class _RecommendedViewState extends State<RecommendedView> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            margin: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: SvgPicture.asset(
                    'assets/Favorite.svg',
                    width: 12,
                    height: 12,
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No se encontraron datos'));
              } else {
                final products = snapshot.data!;
                return ProductCatalog(products: products);
              }
            },
          ),
        ),
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
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        final product = products[index];
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
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
                    'assets/NotFound.png',
                    fit: BoxFit.cover,
                    height: 100,
                    width: double.infinity,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
