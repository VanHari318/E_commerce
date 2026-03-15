// screens/cart_screen.dart
// MÀN HÌNH 3: Giỏ Hàng (Cart Screen)
// Screen 3: Cart Management with Checkbox Selection
//
// Features:
//  • ListView of CartItems with Checkbox per item + swipe-to-delete
//  • "Chọn tất cả" checkbox in sticky bottom bar
//  • +/- quantity controls (quantity=0 → confirm delete dialog)
//  • Dynamic total price based on checked items only
//  • Dismissible items with red background + trash icon
//  • Sticky bottom checkout bar (always visible during scroll)

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';
import 'home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Local state: track which products are selected via checkbox
  late Set<int> _selectedProductIds;

  @override
  void initState() {
    super.initState();
    // Restore selected items from CartProvider (previously saved to SharedPreferences)
    final cart = context.read<CartProvider>();
    _selectedProductIds = Set.from(cart.selectedCheckoutIds);
    debugPrint('CartScreen: Restored $_selectedProductIds from CartProvider');
    if (_selectedProductIds.isEmpty) {
      debugPrint('CartScreen: No selected items to restore (starting fresh)');
    }
  }

  /// Check if all products are selected
  bool get _isSelectAll {
    final cart = context.read<CartProvider>();
    if (cart.isEmpty) return false;
    return _selectedProductIds.length == cart.itemCount;
  }

  /// Calculate total price based on selected items only
  double _calculateTotal() {
    final cart = context.read<CartProvider>();
    double total = 0;
    for (int id in _selectedProductIds) {
      if (cart.items.containsKey(id)) {
        final item = cart.items[id]!;
        total += item.totalPrice;
      }
    }
    return total;
  }

  /// Toggle select all
  void _toggleSelectAll() {
    final cart = context.read<CartProvider>();
    setState(() {
      if (_isSelectAll) {
        _selectedProductIds.clear();
      } else {
        _selectedProductIds = cart.items.keys.toSet();
      }
    });
    // Persist selection to provider so it's saved to SharedPreferences
    cart.setSelectedCheckoutItems(_selectedProductIds);
  }

  /// Toggle single product selection
  void _toggleProductSelection(int productId) {
    final cart = context.read<CartProvider>();
    setState(() {
      if (_selectedProductIds.contains(productId)) {
        _selectedProductIds.remove(productId);
      } else {
        _selectedProductIds.add(productId);
      }
    });
    // Persist selection changes immediately
    cart.setSelectedCheckoutItems(_selectedProductIds);
  }

  /// Show confirm delete dialog when quantity reaches 0
  void _confirmDeleteQuantityZero(int productId, CartItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa sản phẩm'),
        content: Text('Bạn có muốn xóa "${item.product.title}" khỏi giỏ hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartProvider>().removeItem(productId);
              _selectedProductIds.remove(productId);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Navigate to checkout
  /// State Management: Store selected items in Provider, NOT pass via Navigator
  void _goToCheckout() {
    if (_selectedProductIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất 1 sản phẩm')),
      );
      return;
    }

    // Store selected items in CartProvider (State Management Best Practice)
    context.read<CartProvider>().setSelectedCheckoutItems(_selectedProductIds);

    // Navigate to CheckoutScreen WITHOUT passing List
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CheckoutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
            // Ensure selected IDs stay in sync with available cart items
            final missing = _selectedProductIds.where((id) => !cart.items.containsKey(id)).toList();
            if (missing.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                setState(() {
                  _selectedProductIds.removeAll(missing);
                });
                cart.setSelectedCheckoutItems(_selectedProductIds);
              });
            }
          // Empty state
          if (cart.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Giỏ hàng của bạn đang trống',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text('Tiếp tục mua sắm'),
                  ),
                ],
              ),
            );
          }

          // Cart with items
          return Stack(
            children: [
              // Main list
              ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 120),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items.values.elementAt(index);
                  final isSelected =
                      _selectedProductIds.contains(item.product.id);

                  return _CartItemWidget(
                    item: item,
                    isSelected: isSelected,
                    onCheckboxChanged: (value) {
                      _toggleProductSelection(item.product.id);
                    },
                    onIncrement: () {
                      cart.incrementItem(item.product.id);
                    },
                    onDecrement: () {
                      if (item.quantity == 1) {
                        _confirmDeleteQuantityZero(
                          item.product.id,
                          item,
                        );
                      } else {
                        cart.decrementItem(item.product.id);
                      }
                    },
                    onDeleteConfirmed: (productId) {
                      _selectedProductIds.remove(productId);
                    },
                  );
                },
              ),

              // Sticky bottom checkout bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BottomCheckoutBar(
                  selectAllValue: _isSelectAll,
                  selectedCount: _selectedProductIds.length,
                  total: _calculateTotal(),
                  onSelectAll: _toggleSelectAll,
                  onCheckout: _goToCheckout,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE WIDGET: Cart Item Card
// ─────────────────────────────────────────────────────────────────────────────

class _CartItemWidget extends StatelessWidget {
  final CartItem item;
  final bool isSelected;
  final ValueChanged<bool?> onCheckboxChanged;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Function(int) onDeleteConfirmed;

  const _CartItemWidget({
    required this.item,
    required this.isSelected,
    required this.onCheckboxChanged,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDeleteConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(item.product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red.shade600,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      confirmDismiss: (_) async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Xóa sản phẩm'),
            content:
                Text('Bạn có muốn xóa "${item.product.title}" khỏi giỏ hàng?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        if (confirm ?? false) {
          // ignore: use_build_context_synchronously
          context.read<CartProvider>().removeItem(item.product.id);
          onDeleteConfirmed(item.product.id);
        }
        return confirm ?? false;
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox
              Checkbox(
                value: isSelected,
                onChanged: onCheckboxChanged,
                fillColor: WidgetStatePropertyAll(
                  isSelected ? theme.colorScheme.primary : Colors.grey.shade300,
                ),
              ),
              const SizedBox(width: 8),

              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.product.image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported,
                          size: 32, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name (max 2 lines)
                    Text(
                      item.product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Size and Color if available
                    if (item.selectedSize != null ||
                        item.selectedColor != null) ...[
                      Row(
                        children: [
                          if (item.selectedSize != null) ...[
                            Text(
                              'Size: ${item.selectedSize}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            if (item.selectedColor != null)
                              const SizedBox(width: 8),
                          ],
                          if (item.selectedColor != null)
                            Text(
                              'Màu: ${item.selectedColor}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Price
                    Text(
                      item.product.formattedPrice,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Quantity controls
              Column(
                children: [
                  GestureDetector(
                    onTap: onIncrement,
                    child: Icon(Icons.add_circle,
                        size: 24, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: onDecrement,
                    child: Icon(Icons.remove_circle,
                        size: 24, color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE WIDGET: Bottom Checkout Bar (Sticky)
// ─────────────────────────────────────────────────────────────────────────────

class _BottomCheckoutBar extends StatelessWidget {
  final bool selectAllValue;
  final int selectedCount;
  final double total;
  final VoidCallback onSelectAll;
  final VoidCallback onCheckout;

  const _BottomCheckoutBar({
    required this.selectAllValue,
    required this.selectedCount,
    required this.total,
    required this.onSelectAll,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Checkbox "Chọn tất cả"
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: selectAllValue,
                  onChanged: (_) => onSelectAll(),
                  fillColor: WidgetStatePropertyAll(
                    selectAllValue
                        ? theme.colorScheme.primary
                        : Colors.grey.shade300,
                  ),
                ),
                const Text(
                  'Chọn tất cả',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Spacer(),

            // Total price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tổng: ${total.toStringAsFixed(2)}\$',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  '$selectedCount sản phẩm',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Checkout button
            ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Thanh Toán',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
