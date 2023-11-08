import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/View/home.dart';
import 'package:unishop/View/new_post.dart';
import 'package:unishop/Controller/user_posts_controller.dart';

class UserPostsView extends StatefulWidget {
  const UserPostsView({super.key});

  @override
  State<UserPostsView> createState() {
    return _UserPostsViewState();
  }
}

class _UserPostsViewState extends State<UserPostsView> {
  List<ProductDTO> _products = [];
  UserPostController controller = UserPostController();
  StreamSubscription? listener;
  InternetConnectionChecker? customInstance;
  bool? isInternet;
  bool isLoading = true;
  

  @override
  void initState() {
    super.initState();
    customInstance = InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 1), // Custom check timeout
      checkInterval: const Duration(seconds: 1), // Custom check interval
    );
    listener = customInstance!.onStatusChange.listen((status) async {
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
    listener!.cancel();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final loadedProducts = await controller.loadProducts();
    setState(() {
      _products = loadedProducts;
    });
  }

  void _addProduct() async {
    final newProduct = await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const NewPostView(),
      ),
    );

    if (newProduct == null) {
      return;
    }

    setState(() {
      _products.add(newProduct);
    });
  }

  String formatMoney(String money) {
    if (money.isEmpty) {
      return money;
    }
    final format = NumberFormat.decimalPattern("en_US");
    try {
      var moneyAmount = DecimalIntl(Decimal.parse(money));
      return format.format(moneyAmount);
    } catch (e) {
      return money;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;

    if (_products.isEmpty && isInternet == true && isLoading == false) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uh oh ... nothing here!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Try adding a post',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      );
    } else if (_products.isEmpty && isInternet == false && isLoading == false) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,0),
              child: Text(
                'Uh oh! Check if you have internet connection',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 20
                    )
                ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                'Once you have internet connection, your products will be loaded again',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black,
                      fontSize: 15
                    ),
              ),
            ),
          ],
        ),
      );
    }
    else if (_products.isNotEmpty && isLoading == false) {
      content = ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _products.length,
        itemBuilder: (ctx, index) => Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Color.fromARGB(20, 17, 19, 21))),
          clipBehavior: Clip.hardEdge,
          elevation: 5,
          child: Column(
            children: [
              Image.network(_products[index].image.first),
              Container(
                color: Color.fromARGB(255, 217, 217, 217),
                height: 25,
              ),
              Container(
                color: Color.fromARGB(255, 217, 217, 217),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(
                        _products[index].title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color.fromARGB(255, 217, 217, 217),
                height: 15,
              ),
              Container(
                color: Color.fromARGB(255, 217, 217, 217),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Text(
                        "\$ ${formatMoney(_products[index].price.toString())}",
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color.fromARGB(255, 217, 217, 217),
                height: 25,
              ),
            ],
          ),
        ),
      );
    } else if (isLoading == true && isInternet == null){
      content = Center(
      child: CircularProgressIndicator(
        color: Colors.black,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => HomeView(isHome: true),
                maintainState: false,
              )
            );
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'Your Publications',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 22
          ),
        ),
        actions: [
          IconButton(
            onPressed: _addProduct,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
