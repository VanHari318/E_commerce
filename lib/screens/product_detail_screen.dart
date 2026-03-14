// screens/product_detail_screen.dart
// MÀN HÌNH 2: Chi Tiết Sản Phẩm (Product Detail Screen)
// Screen 1 (HomeScreen) navigates here.
// STUB — implemented by team member handling Screen 2.
//
// This file provides the minimal scaffold so the app compiles and navigates
// without errors. The product data is passed in via constructor.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_badge_icon.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentPage = 0;
  bool _descExpanded = false;

  // Simulate multiple images: if only one image exists, replicate it so slider works
  List<String> get _images => [widget.product.image];

  void _openVariationSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        String? selectedSize;
        String? selectedColor;
        int qty = 1;

        return StatefulBuilder(builder: (context, setState) {
          return DraggableScrollableSheet(
            maxChildSize: 0.9,
            initialChildSize: 0.6,
            minChildSize: 0.3,
            builder: (_, controller) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(widget.product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Chọn Kích cỡ',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['S', 'M', 'L'].map((s) {
                      final selected = selectedSize == s;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(s),
                          selected: selected,
                          onSelected: (_) => setState(() => selectedSize = s),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Chọn Màu Sắc',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Xanh', 'Đỏ'].map((c) {
                      final selected = selectedColor == c;
                      final color = c == 'Xanh' ? Colors.blue : Colors.red;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          avatar:
                              CircleAvatar(radius: 8, backgroundColor: color),
                          label: Text(c),
                          selected: selected,
                          onSelected: (_) => setState(() => selectedColor = c),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Số lượng',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() {
                          if (qty > 1) qty--;
                        }),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(qty.toString(),
                          style: const TextStyle(fontSize: 16)),
                      IconButton(
                        onPressed: () => setState(() {
                          qty++;
                        }),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedSize == null || selectedColor == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Vui lòng chọn kích cỡ và màu sắc')),
                            );
                            return;
                          }

                          context.read<CartProvider>().addItem(
                                widget.product,
                                quantity: qty,
                                size: selectedSize,
                                color: selectedColor,
                              );

                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Thêm thành công')),
                          );
                        },
                        child: const Text('Xác nhận'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;
    final originalPrice = (product.price * 1.2).toStringAsFixed(2);

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image slider
                    SizedBox(
                      height: 320,
                      child: Stack(
                        children: [
                          PageView.builder(
                            itemCount: _images.length,
                            onPageChanged: (i) =>
                                setState(() => _currentPage = i),
                            itemBuilder: (context, index) {
                              final url = _images[index];
                              final child = CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.contain,
                                placeholder: (_, __) => Center(
                                    child: CircularProgressIndicator(
                                        color: theme.colorScheme.primary)),
                                errorWidget: (_, __, ___) => const Icon(
                                    Icons.image_not_supported,
                                    size: 80),
                              );

                              // Ensure Hero tag exists on first image for smooth transition
                              if (index == 0) {
                                return Center(
                                  child: Hero(
                                    tag: 'product_image_${product.id}',
                                    child: child,
                                  ),
                                );
                              }
                              return Center(child: child);
                            },
                          ),
                          // Dots
                          Positioned(
                            bottom: 8,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _images.length,
                                (i) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width: _currentPage == i ? 10 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _currentPage == i
                                        ? theme.colorScheme.primary
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Text(product.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '\$${originalPrice}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Phân loại',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Chọn Kích cỡ, Màu sắc'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _openVariationSheet,
                    ),

                    const SizedBox(height: 8),
                    const Text('Mô tả chi tiết',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Builder(builder: (ctx) {
                      final short = widget.product.description.length > 220 &&
                          !_descExpanded;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.description,
                            maxLines: short ? 5 : null,
                            overflow: short
                                ? TextOverflow.ellipsis
                                : TextOverflow.visible,
                            style: const TextStyle(height: 1.5),
                          ),
                          if (widget.product.description.length > 220) ...[
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => setState(
                                  () => _descExpanded = !_descExpanded),
                              child: Text(
                                  _descExpanded ? 'Thu gọn' : 'Xem thêm',
                                  style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ],
                      );
                    }),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),

          // Fixed bottom action bar
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Left half: icons
                SizedBox(
                  width: 120,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Placeholder: open chat — for now show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Mở Chat (chưa triển khai)')));
                        },
                        icon: const Icon(Icons.chat_bubble_outline,
                            color: Colors.black87),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CartScreen())),
                        icon: const Icon(Icons.shopping_cart_outlined,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Right half: action buttons
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _openVariationSheet,
                          icon: const Icon(Icons.add_shopping_cart_outlined),
                          label: Text('Thêm vào giỏ hàng',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // For Buy Now, open variation sheet but pass a flag to navigate to checkout after confirm
                            _openVariationSheet();
                          },
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                          child: const Text('Mua ngay'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
