import 'package:flutter/material.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/widgets/floating_button.dart';
import 'package:unishop/widgets/footer.dart';
import 'package:unishop/widgets/header.dart';
import 'package:unishop/widgets/noconnection.dart';
import 'package:unishop/widgets/product_catalog.dart';
import 'package:unishop/Controller/home_controller.dart';
import 'package:unishop/widgets/noposts.dart';
import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:unishop/widgets/product_detail.dart';

class ProductDetailView extends StatefulWidget {
  final ProductDTO product;
  final int footNumber;
  ProductDetailView(
      {super.key, required this.product, required this.footNumber});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  HomeController homeController = HomeController();
  StreamSubscription? listenerHome;
  InternetConnectionChecker? customInstanceHome;
  bool? isInternet;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    customInstanceHome = InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 1), // Custom check timeout
      checkInterval: const Duration(seconds: 1), // Custom check interval
    );
    listenerHome = customInstanceHome!.onStatusChange.listen((status) async {
      switch (status) {
        case InternetConnectionStatus.connected:
          print('Data connection is available.');
          setState(() {
            isInternet = true;
          });
          break;
        case InternetConnectionStatus.disconnected:
          setState(() {
            isInternet = false;
          });
          print('You are disconnected from the internet.');
          break;
      }
    });
  }

  @override
  dispose() {
    listenerHome!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;
    if (isInternet == false) {
      content = NoInternet();
    } else if (isInternet == true) {
      content = ProductDetail(product: widget.product);
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80, // Custom toolbar height
          automaticallyImplyLeading:
              false, // We will manually add a leading button
          backgroundColor: Colors.white,
          title: Text(
            widget.product.title,
            style: TextStyle(
                color: Colors.black, // Title text color
                fontWeight: FontWeight.bold,
                fontSize: 28),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios, // Use the iOS style back icon
              color: Colors.blue, // Icon color
            ),
            onPressed: () {
              Navigator.of(context)
                  .pop(); 
            },
          ),
        ),
        floatingActionButton: FloatingButton(contextButton: context),
        body: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: content,
        ),
        bottomNavigationBar:
            Footer(currentIndex: widget.footNumber, contextFooter: context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
