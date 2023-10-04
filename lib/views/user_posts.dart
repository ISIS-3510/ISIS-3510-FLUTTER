import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:unishop/models/product.dart';
import 'package:unishop/views/new_post.dart';
//import 'dart:typed_data'; useful for Image.memory

class UserPostsView extends StatefulWidget {
  const UserPostsView({super.key});

  @override
  State<UserPostsView> createState() {
    return _UserPostsViewState();
  }
}

class _UserPostsViewState extends State<UserPostsView> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final queryParameters = {'id': 'b7e0f74e-debe-4dcc-8283-9d6a97e76166'};
    final url = Uri.https(
        'creative-mole-46.hasura.app', 'api/rest/post/user', queryParameters);

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-hasura-admin-secret':
          'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
    });

    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch products. Please try again later.');
    }

    if (response.body == 'null') {
      return;
    }
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<Product> loadedProducts = [];
    for (final items in listData.entries) {
      for (final item in items.value) {
        loadedProducts.add(
          Product(
            title: item['name'],
            description: item['description'],
            price: double.parse(item['price']
                .toString()
                .substring(1)
                .replaceAll('.', '')
                .replaceAll(',', '')),
            isNew: item['new'],
            isRecycled: item['recycled'],
            degree: item['degree'],
            subject: item['subject'],
            image: item['urlsImages'],
          ),
        );
      }
    }

    setState(() {
      _products = loadedProducts;
      print(loadedProducts.length);
    });
  }

  void _addProduct() async {
    final newProduct = await Navigator.of(context).push<Product>(
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

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
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

    if (_products.isNotEmpty) {
      content = ListView.builder(
        itemCount: _products.length,
        itemBuilder: (ctx, index) => Card(
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.hardEdge,
          elevation: 2,
          child: Column(
            children: [
              //Image.memory(Uint8List.fromList(_products[index].image.codeUnits)), Will be used once image is stored as bytes
              Image.network(_products[index].image),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Text(
                    _products[index].title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Publications'),
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
