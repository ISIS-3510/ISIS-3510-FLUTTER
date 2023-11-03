import 'package:flutter/material.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/widgets/floating_button.dart';
import 'package:unishop/widgets/footer.dart';
import 'package:unishop/widgets/header.dart';
import 'package:unishop/widgets/product_catalog.dart';
import 'package:unishop/Controller/recommended_controller.dart';
class RecommendedView extends StatefulWidget {
  @override
  State<RecommendedView> createState() => _RecommendedViewState();
}

class _RecommendedViewState extends State<RecommendedView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 120,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Header(currentIndex: 2),
          ),
          floatingActionButton: FloatingButton(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<ProductDTO>>(
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
          ),
          bottomNavigationBar: Footer(currentIndex:0),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked),
    );
  }

  Future<List<ProductDTO>> fetchProducts() async {
    RecomendedController controller= RecomendedController();
    return controller.getRecommendations();
  }
}

