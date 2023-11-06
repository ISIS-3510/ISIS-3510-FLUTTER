import 'package:flutter/material.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/widgets/floating_button.dart';
import 'package:unishop/widgets/footer.dart';
import 'package:unishop/widgets/header_posts.dart';
import 'package:unishop/widgets/product_catalog.dart';
import 'package:unishop/Controller/recommended_controller.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:unishop/widgets/noposts.dart';
import 'package:unishop/widgets/noconnection.dart';
import 'dart:async';
class RecommendedView extends StatefulWidget {
  @override
  State<RecommendedView> createState() => _RecommendedViewState();
}

class _RecommendedViewState extends State<RecommendedView> {
   List<ProductDTO> _products = [];
  RecomendedController recController = RecomendedController();
  StreamSubscription? listenerRecommended;
  InternetConnectionChecker? customInstanceRecommended;
  bool? isInternet;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    customInstanceRecommended = InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 1), // Custom check timeout
      checkInterval: const Duration(seconds: 1), // Custom check interval
    );
    listenerRecommended = customInstanceRecommended!.onStatusChange.listen((status) async {
      switch (status) {
        case InternetConnectionStatus.connected:
          await _loadProducts();
          print('Data connection is available.');
          setState(() {
            isInternet = true;
            isLoading = false;
          });
          break;
        case InternetConnectionStatus.disconnected:
          setState(() {
            _products = [];
            isInternet = false;
            isLoading = false;
          });
          print('You are disconnected from the internet.') ;
          break;
      }
    });
  }

  @override
  dispose() {
    listenerRecommended!.cancel();
    print('Recommended');
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final loadedProducts = await recController.getRecommendations();
    setState(() {
      _products = loadedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;
    if (_products.isEmpty && isInternet == true && isLoading == false) {
      content = NoDataWidget();
    } else if (_products.isEmpty && isInternet == false && isLoading == false) {
      content = NoInternet();
    } else if (_products.isNotEmpty && isLoading == false) {
      content = ProductCatalog(products: _products);
    } else if (isLoading == true && isInternet == null) {
      content = Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: HeaderPosts(currentIndex: 2, contextHeader: context),
        ),
        floatingActionButton: FloatingButton(contextButton: context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
        bottomNavigationBar:
            Footer(currentIndex: 1, contextFooter: context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

