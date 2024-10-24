import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_manager.dart';
import '../services/wishlist_provider.dart';
import '../util/responsive.dart';

class ProductDetailsDialog extends StatefulWidget {
  final String productId;
  final String productName;
  final double productPrice;
  final String productImage;
  final Future<List<String>> Function() fetchAdditionalImages;

  ProductDetailsDialog({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.fetchAdditionalImages,
  });

  @override
  _ProductDetailsDialogState createState() => _ProductDetailsDialogState();
}

class _ProductDetailsDialogState extends State<ProductDetailsDialog> {
  int _currentIndex = 0;
  int _quantity = 1;
  late Future<List<String>> _additionalImagesFuture;

  @override
  void initState() {
    super.initState();
    _additionalImagesFuture = widget.fetchAdditionalImages();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: responsive.getWidth(0.05),
        vertical: responsive.getHeight(0.1),
      ),
      child: FutureBuilder<List<String>>(
        future: _additionalImagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No additional images found.'));
          }

          List<String> additionalImages = snapshot.data!;

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(responsive.getWidth(0.04)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row with Wish List Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.productName,
                      style: TextStyle(fontSize: responsive.getWidth(0.05), fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite_border), // Wish list icon
                      onPressed: () {
                        Provider.of<WishListProvider>(context, listen: false).addToWishlist(
                          widget.productId,
                          widget.productName,
                          widget.productPrice,
                          widget.productImage
                        );
                        // Optionally, show a message that the item has been added
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${widget.productName} added to wishlist!')),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: responsive.getHeight(0.02)),

                // Image Carousel
                Column(
                  children: [
                    Container(
                      height: responsive.getHeight(0.40),
                      child: PageView.builder(
                        itemCount: additionalImages.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              additionalImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: responsive.getHeight(0.25),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: responsive.getHeight(0.01)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        additionalImages.length,
                            (index) => AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          height: 8.0,
                          width: _currentIndex == index ? 20.0 : 8.0,
                          decoration: BoxDecoration(
                            color: _currentIndex == index ? Colors.black : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.getHeight(0.02)),

                // Price
                Text(
                  'Price: ₹${widget.productPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: responsive.getWidth(0.045)),
                ),
                SizedBox(height: responsive.getHeight(0.02)),

                // Quantity Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      },
                    ),
                    Text(
                      'Quantity: $_quantity',
                      style: TextStyle(fontSize: responsive.getWidth(0.045)),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),

                // Add to Cart Button
                ElevatedButton(
                  onPressed: () {
                    CartManager().addItemToCart({
                      'productId': widget.productId,
                      'productName': widget.productName,
                      'price': widget.productPrice,
                      'quantity': _quantity,
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, responsive.getHeight(0.05)),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: responsive.getWidth(0.05), color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}