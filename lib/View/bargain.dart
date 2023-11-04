import 'package:flutter/material.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/widgets/floating_button.dart';
import 'package:unishop/widgets/footer.dart';
import 'package:unishop/widgets/header_posts.dart';
import 'package:unishop/widgets/product_catalog.dart';
import 'package:unishop/Controller/bargain_Controller.dart';

class BargainView extends StatefulWidget {
  @override
  State<BargainView> createState() => _BargainViewState();
}

class _BargainViewState extends State<BargainView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 120,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: HeaderPosts(currentIndex: 3),
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
          bottomNavigationBar: Footer(currentIndex: 1),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked),
    );
  }

  Future<List<ProductDTO>> fetchProducts() async {
    BargainController controller = BargainController();
    return controller.getBargains();
  }
}
