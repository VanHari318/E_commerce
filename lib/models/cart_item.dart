// models/cart_item.dart
// CartItem wraps a Product with a selected quantity and variation info

import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  String? selectedSize;
  String? selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': product.id,
    'quantity': quantity,
    'selectedSize': selectedSize,
    'selectedColor': selectedColor,
  };
}
