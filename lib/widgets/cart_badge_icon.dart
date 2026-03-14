// widgets/cart_badge_icon.dart
// Cart icon button with animated badge showing item count

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartBadgeIcon extends StatelessWidget {
  final VoidCallback? onTap;

  const CartBadgeIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        return GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: badges.Badge(
              showBadge: cart.itemCount > 0,
              badgeContent: Text(
                cart.itemCount > 99 ? '99+' : cart.itemCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red,
                padding: EdgeInsets.all(5),
              ),
              position: badges.BadgePosition.topEnd(top: -8, end: -8),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        );
      },
    );
  }
}
