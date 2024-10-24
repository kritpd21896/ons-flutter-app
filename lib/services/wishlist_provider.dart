import 'package:flutter/foundation.dart';

class WishListProvider with ChangeNotifier {
  List<Map<String, dynamic>> _wishlistItems = [];

  List<Map<String, dynamic>> get wishlistItems => _wishlistItems;

  void addToWishlist(String productId, String productName, double productPrice, String productImage) {
    // Check if the item already exists in the wishlist
    if (!_wishlistItems.any((item) => item['productId'] == productId)) {
      _wishlistItems.add({
        'productId': productId,
        'productName': productName,
        'productPrice': productPrice,
        'imagePath': productImage
      });
      notifyListeners(); // Notify listeners for state change
    }
  }

  void removeFromWishlist(String productId) {
    _wishlistItems.removeWhere((item) => item['productId'] == productId);
    notifyListeners(); // Notify listeners for state change
  }
}