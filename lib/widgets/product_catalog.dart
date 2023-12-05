import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/Controller/favorite_controller.dart';
import 'package:unishop/View/product_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProductCatalog extends StatefulWidget {
  final List<ProductDTO> products;
  final int footNum;
  ProductCatalog({super.key, required this.products , required this.footNum});

  @override
  State<ProductCatalog> createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  FavoriteController controller = FavoriteController();

  Future<List<ProductDTO>> _loadFavorites() async {
    final loadedFavorites = await controller.getFavorites();
    return loadedFavorites;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductDTO>>(
        future: _loadFavorites(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductDTO>> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: 0.7,
              ),
              itemCount: widget.products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = widget.products[index];
                return GestureDetector(
                  onTap: () {
                    setUp(product);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailView(product: product, footNumber: widget.footNum),
                      ),
                    );
                  },
                  child:
                      ProductCard(product: product, favorites: snapshot.data!),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class ProductCard extends StatefulWidget {
  final ProductDTO product;
  final List<ProductDTO> favorites;
  ProductCard({super.key, required this.product, required this.favorites});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    for (final favorite in widget.favorites) {
      if (favorite.id == widget.product.id) {
        setState(() {
          _isFavorite = true;
        });
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
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
                if (_isValidImageUrl(widget.product.image.first))
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0), // Adjust the top padding value as needed
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        widget.product.image.first,
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0), // Adjust the top padding value as needed
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
                    widget.product.title,
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
                        top: 13.0), // Adjust the top padding value as needed
                    child: Text(
                      "\$ ${formatMoney(widget.product.price.toString())}",
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
                    _isFavorite
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () async {
                    if (_isFavorite) {
                      await FavoriteController()
                          .deleteFavorite(widget.product.id);
                      setState(() {
                        _isFavorite = false;
                      });
                    } else {
                      await FavoriteController().addFavorite(widget.product.id);
                      setState(() {
                        _isFavorite = true;
                      });
                    }
                  },
                )),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 16.0,
                  left: 17.0), // Adjust the top padding value as needed
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  widget.product.getUsername(),
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
  }
  
}
 void setUp(ProductDTO product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('seller_username',product.getUsername());
  }
