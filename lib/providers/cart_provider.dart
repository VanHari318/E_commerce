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
  static const String _selectedCheckoutKey = 'selected_checkout_ids_v1';

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

  // ─── Checkout Selection State ────────────────────────────────────────────

  /// Track selected items for checkout (persisted to SharedPreferences)
  Set<int> _selectedCheckoutIds = {};

  Set<int> get selectedCheckoutIds => _selectedCheckoutIds;

  /// Set selected items for checkout and persist
  void setSelectedCheckoutItems(Set<int> productIds) {
    _selectedCheckoutIds = productIds;
    notifyListeners();
    _saveToPrefs();
  }

  /// Get list of selected CartItems for checkout
  List<CartItem> getSelectedCheckoutItems() {
    return _items.values
        .where((item) => _selectedCheckoutIds.contains(item.product.id))
        .toList();
  }

  /// Clear selected checkout items and persist
  void clearSelectedCheckoutItems() {
    _selectedCheckoutIds.clear();
    notifyListeners();
    _saveToPrefs();
  }

  // ─── Persistence ─────────────────────────────────────────────────────────

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      debugPrint('CartProvider: Saving to SharedPreferences...');

      // Save cart items
      final cartData = _items.values.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, json.encode(cartData));
      debugPrint('CartProvider: ✅ Saved ${_items.length} cart items');

      // Save selected checkout IDs
      final selectedIdsList = _selectedCheckoutIds.toList();
      final stringList = selectedIdsList.map((e) => e.toString()).toList();
      await prefs.setStringList(_selectedCheckoutKey, stringList);
      debugPrint(
          'CartProvider: ✅ Saved ${_selectedCheckoutIds.length} selected checkout IDs: $_selectedCheckoutIds');
    } catch (e) {
      debugPrint('CartProvider: ❌ FAILED to save cart: $e');
    }
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      debugPrint('CartProvider: Loading from SharedPreferences...');

      // Load cart items first
      final cartJson = prefs.getString(_cartKey);
      if (cartJson != null && cartJson.isNotEmpty) {
        try {
          final cartData = json.decode(cartJson) as List;
          _items.clear();
          for (final itemJson in cartData) {
            try {
              final item = CartItem.fromJson(itemJson as Map<String, dynamic>);
              _items[item.product.id] = item;
            } catch (e) {
              debugPrint('CartProvider: ⚠️ Skipped invalid cart item: $e');
              // Skip corrupted items, continue loading others
            }
          }
          debugPrint(
              'CartProvider: ✅ RESTORED ${_items.length} cart items from SharedPreferences');
        } catch (e) {
          debugPrint(
              'CartProvider: ⚠️ Failed to parse cart JSON, clearing old cache: $e');
          await prefs.remove(_cartKey);
        }
      } else {
        debugPrint('CartProvider: No cart items found in SharedPreferences');
      }

      // Load selected checkout IDs
      final selectedIdsList = prefs.getStringList(_selectedCheckoutKey);
      debugPrint(
          'CartProvider: selectedCheckoutKey raw value: $selectedIdsList');

      if (selectedIdsList != null && selectedIdsList.isNotEmpty) {
        _selectedCheckoutIds = selectedIdsList.map((e) => int.parse(e)).toSet();
        debugPrint(
            'CartProvider: ✅ RESTORED ${_selectedCheckoutIds.length} selected checkout items: $_selectedCheckoutIds');
      } else {
        debugPrint(
            'CartProvider: No selected checkout IDs found in SharedPreferences');
      }

      notifyListeners(); // ← Notify UI after load!
      debugPrint('CartProvider: cart persistence ready.');
    } catch (e) {
      debugPrint('CartProvider: ❌ FAILED to load from prefs: $e');
    }
  }
}
