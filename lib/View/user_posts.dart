import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
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

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final loadedProducts = await controller.loadProducts();
    setState(() {
      _products = loadedProducts;
      _loading = false;
    });
  }

  void _addProduct() async {
    final newProduct = await Navigator.of(context).push<ProductDTO>(
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

  bool _loading = true;

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
    Widget content = Center(
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
    );

    if (_products.isEmpty && !_loading) {
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
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ],
        ),
      );
    } else if (_products.isNotEmpty) {
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
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'Your Publications',
          style: Theme.of(context).textTheme.titleLarge,
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
