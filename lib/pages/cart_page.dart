import 'package:flutter/material.dart';
import '../services/cart_manager.dart';
import '../util/responsive.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    List<Map<String, dynamic>> cartItems = CartManager().cartItems;

    // Calculate total price
    double totalPrice = cartItems.fold(0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(responsive.getWidth(0.04)),
        child: cartItems.isEmpty
            ? Center(
          // Display image when the cart is empty
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/message/emptyCart.png', // Your image asset for empty cart
                height: responsive.getHeight(0.3),
                fit: BoxFit.contain,
              ),
              SizedBox(height: responsive.getHeight(0.02)),
              Text(
                'Your cart is empty!',
                style: TextStyle(
                  fontSize: responsive.getWidth(0.05),
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: responsive.getHeight(0.02)),
              Text(
                'Start adding items to your cart.',
                style: TextStyle(
                  fontSize: responsive.getWidth(0.045),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: responsive.getHeight(0.01)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item['productName']} (x${item['quantity']})',
                          style: TextStyle(
                              fontSize: responsive.getWidth(0.045)),
                        ),
                        Text(
                          '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: responsive.getWidth(0.045)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(thickness: 1),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: responsive.getHeight(0.02)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                        fontSize: responsive.getWidth(0.05),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: responsive.getWidth(0.05),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.getHeight(0.02)),
            Text(
              'Estimated delivery time: 30-45 min',
              style:
              TextStyle(fontSize: responsive.getWidth(0.045)),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: responsive.getHeight(0.02)),
              child: ElevatedButton(
                onPressed: () {
                  // Handle order submission
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                      double.infinity, responsive.getHeight(0.08)),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Order Now',
                  style: TextStyle(
                      fontSize: responsive.getWidth(0.05),
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}