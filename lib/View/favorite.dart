import 'package:flutter/material.dart';
import 'package:unishop/Controller/favorite_controller.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/widgets/floating_button.dart';
import 'package:unishop/widgets/footer.dart';
import 'package:unishop/widgets/header.dart';
import 'package:unishop/widgets/product_catalog.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:unishop/widgets/noposts.dart';
import 'package:unishop/widgets/noconnection.dart';
import 'dart:async';


class FavoriteView extends StatefulWidget {
  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  List<ProductDTO> _products = [];
  FavoriteController favController = FavoriteController();
  StreamSubscription? listenerFavorite;
  InternetConnectionChecker? customInstanceFavorite;
  bool? isInternet;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    customInstanceFavorite = InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 1), // Custom check timeout
      checkInterval: const Duration(seconds: 1), // Custom check interval
    );
    listenerFavorite = customInstanceFavorite!.onStatusChange.listen((status) async {
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
          print('You are disconnected from the internet.');
          break;
      }
    });
  }

  @override
  dispose() {
    listenerFavorite!.cancel();
    print('Favorite');
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final loadedProducts = await favController.getFavorites();
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
      content = ProductCatalog(products: _products, footNum: 3);
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
          title: Header(),
        ),
        floatingActionButton: FloatingButton(contextButton: context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
        bottomNavigationBar:
            Footer(currentIndex: 3, contextFooter: context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}