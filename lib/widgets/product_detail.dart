import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:unishop/Model/DTO/product_dto.dart';
import 'package:unishop/Controller/favorite_controller.dart';
import 'package:unishop/View/seller_view.dart';

class ProductDetail extends StatefulWidget {
  final ProductDTO product;
  ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
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
    return Scaffold(
      body: SingleChildScrollView(
        // Use SingleChildScrollView to enable scrolling if content is longer than the screen
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product.image
                  .first, // Assuming imageUrl is a field in ProductDTO
              fit: BoxFit.cover,
              height: 350,
              width: MediaQuery.of(context).size.width,
              // You can set a placeholder image with placeholder: (context, url) => Image.asset('assets/placeholder.png'),
              // Or set an error image with errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 20), // Add some space between image and title
            Text(widget.product.description, style: TextStyle(fontSize: 20)
                // default text style
                ),
            SizedBox(height: 20), // Spacing between title and price
            RichText(
              text: TextSpan(
                style:
                    Theme.of(context).textTheme.bodyLarge, // default text style
                children: <TextSpan>[
                  TextSpan(
                    text: 'Price: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextSpan(
                      text: '\$${formatMoney(widget.product.price.toString())}',
                      style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            SizedBox(height: 6), // Spacing between price and status
            RichText(
              text: TextSpan(
                style:
                    Theme.of(context).textTheme.bodyLarge, // default text style
                children: <TextSpan>[
                  TextSpan(
                    text: 'Status: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextSpan(
                      text: widget.product.isNew ? 'New' : 'Recycled',
                      style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            SizedBox(height: 6), // Spacing between status and subject/degree
            RichText(
              text: TextSpan(
                style:
                    Theme.of(context).textTheme.bodyLarge, // default text style
                children: <TextSpan>[
                  TextSpan(
                    text: 'Subject/Degree: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextSpan(
                    text: '${widget.product.subject}, ${widget.product.degree}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6), // Spacing between subject/degree and location
            RichText(
              text: TextSpan(
                style:
                    Theme.of(context).textTheme.bodyLarge, // default text style
                children: <TextSpan>[
                  TextSpan(
                    text: 'Sold By: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextSpan(
                    text: widget.product.getUsername(),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30), // Spacing between subject/degree and location

            SizedBox(height: 10), // Spacing between subject/degree and location
            SizedBox(
              width: double.infinity, // As wide as the parent container
              height: 60, // Fixed height of 50
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Seller()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(
                      255, 197, 0, 1), // Button background color is blue
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Slightly rounded corners
                  ),
                  elevation: 0, // Removes shadow/elevation if not needed
                ),
                child: Text(
                  'Contact Seller',
                  style: TextStyle(
                    color: Colors.white, // Text color is white
                    fontSize: 18, // Font size for the text
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
