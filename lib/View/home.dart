import 'package:flutter/material.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/widgets/floating_button.dart';
import 'package:unishop/widgets/footer.dart';
import 'package:unishop/widgets/header.dart';
import 'package:unishop/widgets/header_posts.dart';
import 'package:unishop/widgets/noconnection.dart';
import 'package:unishop/widgets/product_catalog.dart';
import 'package:unishop/Controller/home_controller.dart';
import 'package:unishop/widgets/noposts.dart';
import 'dart:async';

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
                  return NoInternet();
                } else if (!snapshot.hasData) {
                  return NoDataWidget();
                } else {
                  final products = snapshot.data!;
                  return ProductCatalog(products: products);
                }
              },
            ),
          ),
          bottomNavigationBar:
              widget.isHome ? Footer(currentIndex: 0) : Footer(currentIndex: 1),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked),
    );
  }

  Future<List<ProductDTO>> fetchProducts() async {
    HomeController controller = HomeController();
    return controller.getListProducts();
  }

  void showAlert(String title, String message, Color backgroundColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            width: 100,
            height: 40,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(message),
                  // Aquí puedes agregar más widgets si es necesario
                ],
              ),
            ),
          ),
          backgroundColor: backgroundColor,
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                    color: Colors.white), // Cambia el color del texto a blanco
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
