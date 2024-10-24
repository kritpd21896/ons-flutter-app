import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ons/pages/wishlist_page.dart';
import 'dart:convert'; // For parsing JSON

import '../util/responsive.dart';
import '../widgets/branding_carousel.dart';
import '../widgets/product_tile.dart';
import '../widgets/search_bar.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = []; // List to store fetched products
  bool isLoading = true; // To show loading spinner

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products on page load
  }

  // Function to fetch products from Spring Boot API
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/products/all')); // Replace with your actual endpoint

      if (response.statusCode == 200) {
        List<dynamic> productList = json.decode(response.body);

        setState(() {
          products = productList.map((product) {
            return {
              'id': product['id'],
              'name': product['productName'],
              'price': product['productPrice'],
              'image': product['productImage'] // Assuming this is the image URL
            };
          }).toList();
          isLoading = false; // Data is fetched, stop loading
        });
      } else {
        // Handle the case when the server returns an error
        print('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: <Widget>[
      SliverAppBar(
      backgroundColor: Colors.white,
        elevation: 0,
        expandedHeight: responsive.getHeight(0.2),
        flexibleSpace: FlexibleSpaceBar(
          background: Column(
            children: [
              // Create a Row for logo and wishlist icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo on the left
                  Container(
                    padding: EdgeInsets.all(responsive.getWidth(0.02)),
                    child: Image.asset(
                      'assets/logos/ons.png',
                      fit: BoxFit.contain,
                      height: responsive.getHeight(0.1),
                    ),
                  ),
                  // Wishlist icon on the right
                  IconButton(
                    icon: Icon(Icons.favorite, color: Colors.pinkAccent), // Wishlist icon
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WishlistPage()),
                      );
                    },
                  ),
                ],
              ),
              // Search bar below the logo and wishlist icon
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(searchQuery: 'Your Search Query'),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.getWidth(0.02)),
                  child: CustomSearchBar(),
                ),
              ),
            ],
          ),
        ),
        pinned: false,
        floating: false,
        foregroundColor: Colors.white,
      ),
          // Branding carousel
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(responsive.getWidth(0.02)),
              child: BrandingCarousel(brandingImages: [
                'assets/logos/ons.png',
                'assets/logos/ons.png',
                'assets/logos/ons.png',
                'assets/logos/ons.png',
              ]), // Directly use the BrandingCarousel widget
            ),
          ),
          // Add product tiles or other widgets below
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.getWidth(0.02)),
              child: Text(
                'Recommended for You',
                style: TextStyle(fontSize: responsive.getWidth(0.06), fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: responsive.getHeight(0.25),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductTile(
                    productId: product['id'].toString(),
                    productName: product['name'].toString(),
                    productPrice: product['price'],
                    imagePath: product['image'].toString(),
                  );
                },
              ),
            ),
          ),
          // Other sections like favorite brands and new in town can be added similarly...
        ],
      ),
    );
  }
}