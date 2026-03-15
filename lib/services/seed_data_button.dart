import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_data.dart';

class SeedDataButton extends StatelessWidget {
  const SeedDataButton({Key? key}) : super(key: key);

  Future<void> seedProducts(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('products');

    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang tải dữ liệu lên Firestore...')),
      );

      // Loop through all mock products and upload
      for (var product in mockProducts) {
        // Use the product ID as the document ID for consistency
        await collection.doc(product.id.toString()).set(product.toJson());
      }

      // Show success
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tải lên Firestore thành công!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.cloud_upload),
      onPressed: () => seedProducts(context),
      tooltip: 'Tải 30 sản phẩm lên Firebase',
    );
  }
}
