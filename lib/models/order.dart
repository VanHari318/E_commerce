// lib/models/order.dart
import 'cart_item.dart';

enum OrderStatus {
  pending,      // Chờ xác nhận
  shipping,     // Đang giao
  delivered,    // Đã giao
  cancelled     // Đã hủy
}

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime dateTime;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.dateTime,
    this.status = OrderStatus.pending,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((x) => x.toJson()).toList(),
        'totalAmount': totalAmount,
        'dateTime': dateTime.toIso8601String(),
        'status': status.name,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        items: List<CartItem>.from(
            (json['items'] as List).map((x) => CartItem.fromJson(x as Map<String, dynamic>))),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        dateTime: DateTime.parse(json['dateTime'] as String),
        status: OrderStatus.values.byName(json['status'] as String),
      );

  String get statusDisplay {
    switch (status) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.shipping:
        return 'Đang giao';
      case OrderStatus.delivered:
        return 'Đã giao';
      case OrderStatus.cancelled:
        return 'Đã hủy';
    }
  }
}
