// lib/providers/order_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  static const String _orderKey = 'order_history_v1';

  OrderProvider() {
    _loadFromPrefs();
  }

  List<OrderModel> get orders => List.unmodifiable(_orders);

  /// Add a new order and persist
  void addOrder(OrderModel order) {
    _orders.insert(0, order); // Add new orders to the top
    notifyListeners();
    _saveToPrefs();
  }


  /// Update an order's status and persist
  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = OrderModel(
        id: _orders[index].id,
        items: _orders[index].items,
        totalAmount: _orders[index].totalAmount,
        dateTime: _orders[index].dateTime,
        status: newStatus,
      );
      notifyListeners();
      _saveToPrefs();
    }
  }


  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderData = _orders.map((order) => order.toJson()).toList();
      await prefs.setString(_orderKey, json.encode(orderData));
      debugPrint('OrderProvider: ✅ Saved ${_orders.length} orders');
    } catch (e) {
      debugPrint('OrderProvider: ❌ FAILED to save orders: $e');
    }
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderJson = prefs.getString(_orderKey);
      if (orderJson != null && orderJson.isNotEmpty) {
        final List<dynamic> orderData = json.decode(orderJson);
        _orders.clear();
        for (var item in orderData) {
          _orders.add(OrderModel.fromJson(item as Map<String, dynamic>));
        }
        debugPrint('OrderProvider: ✅ Loaded ${_orders.length} orders');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('OrderProvider: ❌ FAILED to load orders: $e');
    }
  }
}
