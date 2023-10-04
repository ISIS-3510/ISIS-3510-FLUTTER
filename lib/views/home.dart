import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unishop/views/user_posts.dart';

class Product {
  final String id;
  final String degree;
  final String description;
  final bool isNew;
  final String price;
  final bool recycled;
  final String subject;
  final List<String> imageUrls;
  final String date;
  final String name;
  final String userName;

  Product({
    required this.id,
    required this.degree,
    required this.description,
    required this.isNew,
    required this.price,
    required this.recycled,
    required this.subject,
    required this.imageUrls,
    required this.date,
    required this.name,
    required this.userName,
  });
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0; // To keep track of the selected item in the footer.
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            margin:
                EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0), // Add top margin here
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                //Use SvgPicture.asset to display the SVG icon
                Padding(
                  padding: EdgeInsets.only(left: 25.0), // Add left padding here
                  child: SvgPicture.asset(
                    'assets/Favorite.svg', // Replace with your SVG file path
                    width: 12, // Set the width of the SVG icon
                    height: 12, // Set the height of the SVG icon
                    colorFilter: ColorFilter.mode(Colors.black,
                        BlendMode.srcIn), // Set the color of the SVG icon
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Products',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Product>>(
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType
              .fixed, // To display all items, even if there are more than 3.
          selectedItemColor: Colors.orange, // Color for the selected item.
          unselectedItemColor: Colors.grey,
          selectedLabelStyle:
              TextStyle(color: Colors.orange), // Color for unselected items.

          onTap: (index) {
            //Handle item tap here.
            setState(() {
              _currentIndex = index;
            });

            //Perform navigation based on the tapped item.
            switch (index) {
              case 0:
                //Navigate to the Home page.
                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                break;
              case 1:
                //Navigate to the Favorites page.
                // Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen()));
                break;
              case 2:
                //Navigate to the Map page.
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
                break;
              case 3:
                //Navigate to the History page.
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserPostsView()));
                break;
              case 4:
                //Navigate to the Chat page.
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                break;
            }
          },
          items: [
            //Define the items in the footer.
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/Home.svg', width: 30, height: 30),
              label: 'Home',
              activeIcon: SvgPicture.asset('assets/Home.svg',
                  colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                  width: 30,
                  height: 30),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/Favorite.svg',
                  width: 30, height: 30),
              label: 'Favorite',
              activeIcon: SvgPicture.asset('assets/Favorite.svg',
                  colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                  width: 30,
                  height: 30),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/Map.svg', width: 30, height: 30),
              label: 'Map',
              activeIcon: SvgPicture.asset('assets/Map.svg',
                  colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                  width: 30,
                  height: 30),
            ),
            BottomNavigationBarItem(
              icon:
                  SvgPicture.asset('assets/History.svg', width: 30, height: 30),
              label: 'History',
              activeIcon: SvgPicture.asset('assets/History.svg',
                  colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                  width: 30,
                  height: 30),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/Chat.svg', width: 30, height: 30),
              label: 'Chat',
              activeIcon: SvgPicture.asset('assets/Chat.svg',
                  colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                  width: 30,
                  height: 30),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Product>> fetchProducts() async {
    final url =
        Uri.parse('https://creative-mole-46.hasura.app/api/rest/post/all');
    final headers = {
      'content-type': 'application/json',
      'x-hasura-admin-secret':
          'mmjEW9L3cf3SZ0cr5pb6hnnnFp1ud4CB4M6iT1f0xYons16k2468G9SqXS9KgdAZ',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> postList = jsonData['post'];

      final List<Product> products = postList.map((item) {
        final imageUrls = (item['urlsImages'] as String).split(';');
        return Product(
          id: item['id'],
          degree: item['degree'],
          description: item['description'],
          isNew: item['new'],
          price: item['price'],
          recycled: item['recycled'],
          subject: item['subject'],
          imageUrls: imageUrls,
          date: item['date'],
          name: item['name'],
          userName: item['user']['username'],
        );
      }).toList();

      return products;
    } else {
      throw Exception('Error al cargar los productos');
    }
  }
}

class ProductCatalog extends StatelessWidget {
  final List<Product> products;
   bool _isValidImageUrl(String imageUrl) {
    return imageUrl.startsWith('h'.trim());
  }

  ProductCatalog({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dos productos por fila
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        final product = products[index];
        return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10.0), // Ajusta el radio según tus preferencias
            ),
            child: SizedBox(
              height: 00,
              child: Column(
                children: [
                  if (_isValidImageUrl(product.imageUrls.first))
                    Image.network(
                      product.imageUrls.first,
                      fit: BoxFit.cover,
                      height: 100,
                      width: double.infinity,
                    )
                  else
                    Image.asset(
                      'assets/NotFound.png', // Replace with the path to your placeholder image
                      fit: BoxFit.cover,
                      height: 100,
                      width: double.infinity,
                    ),
                  ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                      product.description,
                      maxLines: 1, // Limita a dos líneas de texto
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                  //   child: Text(
                  //     product.price,
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ));
      },
    );
  }
}
