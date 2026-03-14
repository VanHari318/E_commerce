// screens/product_detail_screen.dart
// MÀN HÌNH 2: Chi Tiết Sản Phẩm (Product Detail Screen)
// Screen 1 (HomeScreen) navigates here.
// STUB — implemented by team member handling Screen 2.
//
// This file provides the minimal scaffold so the app compiles and navigates
// without errors. The product data is passed in via constructor.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_badge_icon.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Sản Phẩm'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          CartBadgeIcon(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
          ),
        ],
      ),
      // TODO (Screen 2): Replace body with full product detail UI.
      // Requirements:
      //  • Hero image slider (matches Hero tag 'product_image_${product.id}')
      //  • Price block (red current price + strikethrough original)
      //  • Variation selector (size/color) via BottomSheet
      //  • Description with "Xem thêm" expand/collapse
      //  • Sticky bottom bar with "Thêm vào giỏ" and "Mua ngay" buttons
      //  • SnackBar "Thêm thành công" after adding to cart
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Hero transition
            Center(
              child: Hero(
                tag: 'product_image_${product.id}',
                child: Image.network(
                  product.image,
                  height: 260,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 120),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.formattedPrice,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber.shade600, size: 18),
                Text(' ${product.rating.rate} · ${product.soldCount}'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Mô Tả Sản Phẩm',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(product.description, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 24),
            // Placeholder "Thêm vào giỏ" button — functional basic version
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Thêm vào giỏ hàng',
                    style: TextStyle(fontSize: 15)),
                onPressed: () {
                  context.read<CartProvider>().addItem(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('✅ Thêm vào giỏ thành công!'),
                      backgroundColor: Colors.green.shade700,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
