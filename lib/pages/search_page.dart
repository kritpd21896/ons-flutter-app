import 'package:flutter/material.dart';
import '../util/responsive.dart';
import '../widgets/product_tile.dart';

class SearchPage extends StatelessWidget {
  final String searchQuery;

  SearchPage({required this.searchQuery});

  // Simulate loading products based on search query
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    // Simulate a network delay
    await Future.delayed(Duration(seconds: 2));

    // In a real app, replace this with your API call to fetch products
    return [
      {
        'id': '1',
        'imageUrl': 'assets/logos/ons.png',
        'name': 'Product 1',
        'price': 29.99,
      },
      {
        'id': '2',
        'imageUrl': 'assets/logos/ons.png',
        'name': 'Product 2',
        'price': 19.99,
      },
      // Add more products as needed
    ]; // Dummy product data
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button
          onPressed: () {
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
        backgroundColor: Colors.white, // Keep background white
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProducts(), // Fetch products asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found.'));
          }

          List<Map<String, dynamic>> products = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(responsive.getWidth(0.04)), // Responsive padding
                child: Text(
                  'Search Results for "$searchQuery"',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: responsive.getWidth(0.04)), // Responsive padding
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of tiles in a row
                    childAspectRatio: 1, // Make it square
                    crossAxisSpacing: responsive.getWidth(0.04), // Space between columns
                    mainAxisSpacing: responsive.getHeight(0.02), // Space between rows
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductTile(
                      imagePath: products[index]['imageUrl'],
                      productId: products[index]['id'],
                      productName: products[index]['name'],
                      productPrice: products[index]['price'],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}