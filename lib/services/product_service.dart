// services/product_service.dart
// Handles all Firestore database queries for products

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch paginated products from Firestore.
  /// Note: Offset pagination in Firestore requires DocumentSnapshots, 
  /// but for simplicity and small dataset here, we'll fetch ordered by ID.
  Future<List<Product>> fetchProducts({int limit = 10, int offset = 0}) async {
    final snapshot = await _firestore
        .collection('products')
        .orderBy('id')
        .limit(offset + limit)
        .get();

    final items = snapshot.docs
        .map((doc) => Product.fromJson(doc.data()))
        .toList();

    if (offset >= items.length) return [];
    final end = (offset + limit < items.length) ? offset + limit : items.length;
    return items.sublist(offset, end);
  }

  /// Fetch all available categories dynamically from the products collection
  Future<List<String>> fetchCategories() async {
    final snapshot = await _firestore.collection('products').get();
    
    // Extract unique categories
    final Set<String> categories = {};
    for (var doc in snapshot.docs) {
      if (doc.data().containsKey('category')) {
         categories.add(doc.data()['category'] as String);
      }
    }
    
    return categories.toList()..sort();
  }

  /// Fetch a single product by ID
  Future<Product> fetchProductById(int id) async {
    final doc = await _firestore.collection('products').doc(id.toString()).get();
    
    if (doc.exists && doc.data() != null) {
      return Product.fromJson(doc.data()!);
    } else {
      throw Exception('Product $id not found in Firestore');
    }
  }

  /// Fetch products by category
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs
        .map((doc) => Product.fromJson(doc.data()))
        .toList();
  }
}
