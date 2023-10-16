import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unishop/models/product.dart';
import 'package:unishop/repositories/posts_repository.dart';
import 'package:unishop/views/bargain.dart';
import 'package:unishop/views/recommended.dart';
import 'package:unishop/views/user_posts.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


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
  toolbarHeight: 120,
  automaticallyImplyLeading: false,
  backgroundColor: Colors.white,
  title: Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        margin: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: SvgPicture.asset(
                'assets/Favorite.svg',
                width: 12,
                height: 12,
                colorFilter: ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
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
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange[300],
              ),
              onPressed: redAllProducts,
              child: Text(
                'All Products',
                style: TextStyle(color: Colors.black), // Cambia el color del texto a negro
              ),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            flex: 1,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[300],
              ),
              onPressed: redRecommended,
              child: Text(
                'Recommended',
                style: TextStyle(color: Colors.black), // Cambia el color del texto a negro
              ),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            flex: 1,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[300],
              ),
              onPressed: redBargain,
              child: Text(
                'Bargains',
                style: TextStyle(color: Colors.black), // Cambia el color del texto a negro
              ),
            ),
          ),
        ],
      ),
    ],
  ),
)
,

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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeView()));
                  break;
                case 1:
                  //Navigate to the Favorites page.
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecommendedView()));
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
                icon:
                    SvgPicture.asset('assets/Home.svg', width: 30, height: 30),
                label: 'Home',
                activeIcon: SvgPicture.asset('assets/Home.svg',
                    colorFilter:
                        ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                    width: 30,
                    height: 30),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/Favorite.svg',
                    width: 30, height: 30),
                label: 'Favorite',
                activeIcon: SvgPicture.asset('assets/Favorite.svg',
                    colorFilter:
                        ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                    width: 30,
                    height: 30),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.map_outlined,
                  color: Color.fromRGBO(0, 0, 0, 0),
                ),
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/History.svg',
                    width: 30, height: 30),
                label: 'History',
                activeIcon: SvgPicture.asset('assets/History.svg',
                    colorFilter:
                        ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                    width: 30,
                    height: 30),
              ),
              BottomNavigationBarItem(
                icon:
                    SvgPicture.asset('assets/Chat.svg', width: 30, height: 30),
                label: 'Chat',
                activeIcon: SvgPicture.asset('assets/Chat.svg',
                    colorFilter:
                        ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                    width: 30,
                    height: 30),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked),
    );
  }

  Future<List<Product>> fetchProducts() async {
    return PostsRepository.getListProducts();
  }

  void redBargain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BargainView(),
      ),
    );
  }

  void redRecommended(){
    Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RecommendedView(),
            ),
          );
  }

  void redAllProducts(){
    Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeView(),
            ),
          );
  }
}

class ProductCatalog extends StatelessWidget {
  final List<Product> products;
  bool _isValidImageUrl(String imageUrl) {
    return imageUrl.startsWith('h'.trim());
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

  ProductCatalog({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        final product = products[index];
        return Container(
          color: Colors.white, // Set the background color of the container
          child: Card(
            elevation: 5,
            color: Colors.white, // Set the background color of the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    if (_isValidImageUrl(product.image.first))
                      Padding(
                        padding: EdgeInsets.only(
                            top:
                                10.0), // Adjust the top padding value as needed
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            product.image.first,
                            fit: BoxFit.cover,
                            height: 150,
                            width: 150,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.only(
                            top:
                                10.0), // Adjust the top padding value as needed
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset(
                            'assets/NotFound.png',
                            fit: BoxFit.cover,
                            height: 150,
                            width: 150,
                          ),
                        ),
                      ),
                    ListTile(
                      title: Text(
                        product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(
                            top:
                                13.0), // Adjust the top padding value as needed
                        child: Text(
                          "\$ ${formatMoney(product.price.toString())}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.heart,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        // Handle the icon tap here
                      },
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 16.0,
                      left: 17.0), // Adjust the top padding value as needed
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      product.getUsername(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color.fromARGB(141, 89, 89, 89),
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
