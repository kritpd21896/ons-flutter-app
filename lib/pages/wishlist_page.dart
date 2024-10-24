import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wishlist_provider.dart';
import '../widgets/product_tile.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wishlist')),
      body: Consumer<WishListProvider>(
        builder: (context, wishlistProvider, child) {
          if (wishlistProvider.wishlistItems.isEmpty) {
            return Center(child: Text('Your wishlist is empty.'));
          }

          return ListView.builder(
            itemCount: wishlistProvider.wishlistItems.length,
            itemBuilder: (context, index) {
              final item = wishlistProvider.wishlistItems[index];
              return ProductTile(
                productId: item['productId'],
                productName: item['productName'],
                productPrice: item['productPrice'],
                imagePath: item['imagePath'], // Ensure you have an image path if needed
              );
            },
          );
        },
      ),
    );
  }
}