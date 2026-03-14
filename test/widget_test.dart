// test/widget_test.dart
// Basic smoke test for TH4 - Nhóm 11 E-Commerce App

import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce/main.dart';
import 'package:e_commerce/providers/cart_provider.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const ECommerceApp());
    await tester.pump(const Duration(milliseconds: 100));
    // App should not throw on startup
  });

  test('CartProvider initializes empty', () {
    final cart = CartProvider();
    expect(cart.itemCount, 0);
    expect(cart.totalPrice, 0.0);
    expect(cart.isEmpty, true);
  });
}
