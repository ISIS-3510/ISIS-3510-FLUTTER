import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:unishop/models/product.dart';

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