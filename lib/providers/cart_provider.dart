// providers/cart_provider.dart
// Global cart state management using Provider
// Persists cart data to SharedPreferences

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  // Map: productId -> CartItem
  final Map<int, CartItem> _items = {};
  static const String _cartKey = 'cart_items_v1';

  CartProvider() {
    _loadFromPrefs();
  }

  // ─── Getters ───────────────────────────────────────────────────────────────

  Map<int, CartItem> get items => Map.unmodifiable(_items);

  /// Total number of unique product types in cart
  int get itemCount => _items.length;

  /// Total quantity across all items
  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  /// Total price of all items
  double get totalPrice =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => _items.isEmpty;

  // ─── Actions ───────────────────────────────────────────────────────────────

  /// Add a product to cart (or increment if already exists)
  void addItem(
    Product product, {
    int quantity = 1,
    String? size,
    String? color,
  }) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(
        product: product,
        quantity: quantity,
        selectedSize: size,
        selectedColor: color,
      );
    }
    notifyListeners();
    _saveToPrefs();
  }

  /// Remove a product entirely from cart
  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
    _saveToPrefs();
  }

  /// Update quantity of a cart item; if quantity <= 0, removes the item
  void updateQuantity(int productId, int quantity) {
    if (!_items.containsKey(productId)) return;
    if (quantity <= 0) {
      removeItem(productId);
    } else {
      _items[productId]!.quantity = quantity;
      notifyListeners();
      _saveToPrefs();
    }
  }

  /// Increment quantity by 1
  void incrementItem(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();
      _saveToPrefs();
    }
  }

  /// Decrement quantity by 1; removes item if quantity reaches 0
  void decrementItem(int productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity <= 1) {
      removeItem(productId);
    } else {
      _items[productId]!.quantity--;
      notifyListeners();
      _saveToPrefs();
    }
  }

  /// Clear all items (e.g., after checkout)
  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveToPrefs();
  }

  /// Remove a list of product IDs (e.g., after checkout of selected items)
  void removeItems(List<int> productIds) {
    for (final id in productIds) {
      _items.remove(id);
    }
    notifyListeners();
    _saveToPrefs();
  }

  bool containsProduct(int productId) => _items.containsKey(productId);

  // ─── Persistence ─────────────────────────────────────────────────────────

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Only save product IDs and quantities (products re-fetched on startup as needed)
      final cartData = _items.values.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, json.encode(cartData));
    } catch (e) {
      debugPrint('CartProvider: failed to save cart: $e');
    }
  }

  Future<void> _loadFromPrefs() async {
    // Cart items require full product data — to keep things simple for Screen 1,
    // we skip restoring cart on startup (teams implementing Screen 2+ can extend this).
    // Full persistence with product fetch can be added in later screens.
    debugPrint('CartProvider: cart persistence ready.');
  }
}
