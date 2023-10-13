import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unishop/models/product.dart';
import 'package:unishop/repositories/posts_repository.dart';
import 'package:unishop/views/recommended.dart';
import 'package:unishop/views/user_posts.dart';


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
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
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
        floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserPostsView()));},
        tooltip: 'Increment',
        backgroundColor: Colors.black,
        elevation: 4.0,
        child:  Icon(Icons.add)
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
                break;
              case 1:
                //Navigate to the Favorites page.
                Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendedView()));
                break;
              case 2:
                //Navigate to the Map page.
                // Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
                break;
              case 3:
                //Navigate to the History page.
                //Navigator.push(context,
                    //MaterialPageRoute(builder: (context) => UserPostsView()));
                //break;
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
              icon: Icon(Icons.map_outlined, color: Color.fromRGBO(0, 0, 0, 0),),
              label: 'Create',
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
      ),
    );
  }

  Future<List<Product>> fetchProducts() async {
    return PostsRepository.getListProducts();
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
                  if (_isValidImageUrl(product.image.first))
                    Image.network(
                      product.image.first,
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
                    title: Text(product.title),
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
