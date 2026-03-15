// lib/screens/order_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';


class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch sử đơn hàng'),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Chờ xác nhận'),
              Tab(text: 'Đang giao'),
              Tab(text: 'Đã giao'),
              Tab(text: 'Đã hủy'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _OrderList(status: OrderStatus.pending),
            _OrderList(status: OrderStatus.shipping),
            _OrderList(status: OrderStatus.delivered),
            _OrderList(status: OrderStatus.cancelled),
          ],
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final OrderStatus status;

  const _OrderList({required this.status});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final filteredOrders = orderProvider.orders
            .where((order) => order.status == status)
            .toList();

        if (filteredOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined,
                    size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  'Chưa có đơn hàng nào',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            final order = filteredOrders[index];
            return _OrderCard(order: order);
          },
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(order.dateTime);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn hàng: #${order.id.substring(order.id.length - 6)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<OrderStatus>(
                  value: order.status,
                  underline: const SizedBox.shrink(),
                  icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onChanged: (OrderStatus? newStatus) {
                    if (newStatus != null) {
                      context.read<OrderProvider>().updateOrderStatus(order.id, newStatus);
                    }
                  },
                  items: OrderStatus.values.map((status) {
                    return DropdownMenuItem<OrderStatus>(
                      value: status,
                      child: Text(_getStatusLabel(status)),
                    );
                  }).toList(),
                ),

              ],
            ),
            const Divider(),
            ...order.items.take(2).map((CartItem item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      item.product.image,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item.product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                  subtitle: Text('x${item.quantity}', style: const TextStyle(fontSize: 12)),
                  trailing: Text(
                    item.product.formattedPrice,
                    style: const TextStyle(fontSize: 13),
                  ),
                )),

            if (order.items.length > 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Xem thêm ${order.items.length - 2} sản phẩm...',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      const TextSpan(text: 'Thành tiền: '),
                      TextSpan(
                        text: '\$${order.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  String _getStatusLabel(OrderStatus status) {
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
