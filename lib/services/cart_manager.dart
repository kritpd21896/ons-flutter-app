class CartManager {
  static final CartManager _instance = CartManager._internal();

  factory CartManager() {
    return _instance;
  }

  CartManager._internal();

  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addItemToCart(Map<String, dynamic> product) {
    // Check if item already exists in the cart, update quantity if so
    int index = _cartItems.indexWhere((item) => item['productId'] == product['productId']);
    if (index != -1) {
      _cartItems[index]['quantity'] += product['quantity'];
    } else {
      _cartItems.add(product);
    }
  }

  void updateQuantity(String productId, int quantity) {
    int index = _cartItems.indexWhere((item) => item['productId'] == productId);
    if (index != -1) {
      _cartItems[index]['quantity'] = quantity;
    }
  }

  void removeItemFromCart(String productId) {
    _cartItems.removeWhere((item) => item['productId'] == productId);
  }
}