import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ons/widgets/product_details_dialog.dart';
import 'package:http/http.dart' as http;
import '../util/responsive.dart';

class ProductTile extends StatelessWidget {
  final String productId;
  final String productName;
  final double productPrice;
  final String imagePath;

  ProductTile({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.imagePath,
  });

  Future<List<String>> fetchAdditionalImages() async {
    // Replace with your actual API URL
    final String apiUrl = 'http://localhost:8080/productImages/$productId';

    // Make the HTTP GET request
    final response = await http.get(Uri.parse(apiUrl));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> jsonResponse = json.decode(response.body);

      // Extract image URLs from the response
      if (jsonResponse.isNotEmpty) {
        final Map<String, dynamic> images = jsonResponse[0]; // Assuming the first item contains the images
        return [
          images['imageUrl1'] as String,
          images['imageUrl2'] as String,
          images['imageUrl3'] as String,
          images['imageUrl4'] as String,
          images['imageUrl5'] as String,
        ].where((url) => url.isNotEmpty).toList(); // Exclude empty URLs
      } else {
        return []; // Return an empty list if no images found
      }
    } else {
      throw Exception('Failed to load additional images');
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);

    return GestureDetector(
      onTap: () {
        // Show the product details dialog
        showDialog(
          context: context,
          builder: (context) {
            return ProductDetailsDialog(
              productId: productId,
              productName: productName,
              productPrice: productPrice,
              productImage: imagePath,
              fetchAdditionalImages: fetchAdditionalImages,
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.all(responsive.getWidth(0.02)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imagePath, // Using NetworkImage to load the image from a URL
            fit: BoxFit.cover,
            width: responsive.getWidth(0.4),
            height: responsive.getWidth(0.4),
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error); // Placeholder for error handling
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}