// screens/checkout_screen.dart
// MÀN HÌNH 4: Thanh Toán & Đơn Mua (Checkout & Orders)
// STUB — implemented by team member handling Screen 4.
//
// Receives the list of selected CartItems from CartScreen.
// After "Đặt hàng": shows success dialog, clears those items from CartProvider,
// and pushes back to HomeScreen.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'cod';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh Toán'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          final List<CartItem> selectedItems = cart.getSelectedCheckoutItems();


          if (selectedItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Không có sản phẩm để thanh toán',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Quay lại'),
                  ),
                ],
              ),
            );
          }

          final total =
              selectedItems.fold(0.0, (sum, item) => sum + item.totalPrice);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order summary
                Card(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.receipt_long),
                        title: Text('Đơn hàng của bạn',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ...selectedItems.map(
                        (item) => ListTile(
                          leading: Image.network(
                            item.product.image,
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                          title: Text(item.product.title,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: Text(
                            '${item.product.formattedPrice} × ${item.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tổng cộng:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Placeholder address field
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ nhận hàng',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                // Placeholder payment method
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Text(
                          'Phương thức thanh toán',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        leading: Radio<String>(
                          value: 'cod',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() => _selectedPaymentMethod = value!);
                          },
                        ),
                        title: const Text('💵 COD - Thanh toán khi nhận hàng'),
                        onTap: () {
                          setState(() => _selectedPaymentMethod = 'cod');
                        },
                      ),
                      ListTile(
                        leading: Radio<String>(
                          value: 'momo',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() => _selectedPaymentMethod = value!);
                          },
                        ),
                        title: const Text('💜 Momo'),
                        onTap: () {
                          setState(() => _selectedPaymentMethod = 'momo');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _placeOrder(context, selectedItems, cart),
                    child: const Text('ĐẶT HÀNG',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  Future<void> _placeOrder(BuildContext context, List<CartItem> selectedItems,
      CartProvider cart) async {
    // Show success dialog
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Đặt hàng thành công!'),
          ],
        ),
        content:
            const Text('Đơn hàng của bạn đã được đặt.\nCảm ơn bạn đã mua sắm!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Save order to history
      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: List<CartItem>.from(selectedItems),
        totalAmount: selectedItems.fold(0.0, (sum, item) => sum + item.totalPrice),
        dateTime: DateTime.now(),
        status: OrderStatus.pending,
      );
      context.read<OrderProvider>().addOrder(order);

      // Remove purchased items from cart
      cart.removeItems(selectedItems.map<int>((item) => item.product.id).toList());



      // Clear selected checkout items
      cart.clearSelectedCheckoutItems();

      // Navigate back to HomeScreen clearing the stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }
}
