import 'package:flutter/material.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/widgets/floating_button.dart';
import 'package:unishop/widgets/footer.dart';
import 'package:unishop/widgets/header.dart';
import 'package:unishop/widgets/header_posts.dart';
import 'package:unishop/widgets/product_catalog.dart';
import 'package:unishop/Controller/home_controller.dart';

class HomeView extends StatefulWidget {
  final bool isHome;
  HomeView({super.key, required this.isHome});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 120,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: widget.isHome ? Header() : HeaderPosts(currentIndex: 1),
          ),
          floatingActionButton: FloatingButton(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<ProductDTO>>(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
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
          ),
          bottomNavigationBar: widget.isHome ? Footer(currentIndex: 0) : Footer(currentIndex: 1),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked),
    );
  }

  Future<List<ProductDTO>> fetchProducts() async {
    HomeController controller = HomeController();
    return controller.getListProducts();
  }
}
