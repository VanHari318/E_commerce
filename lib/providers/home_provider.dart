// providers/home_provider.dart
// Manages home screen state: products list, categories, pagination, loading

import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class HomeProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  // Products
  List<Product> _products = [];
  List<String> _categories = [];
  String? _selectedCategory;

  // Search
  String _searchQuery = '';
  List<Product> _searchResults = [];

  // Pagination
  final int _pageSize = 10;
  bool _isLoadingInitial = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;

  // ─── Getters ───────────────────────────────────────────────────────────────

  List<Product> get products => isSearching ? _searchResults : _products;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  bool get isLoadingInitial => _isLoadingInitial;
  bool get isLoadingMore => _isLoadingMore;
  // Disable infinite scroll & "hasMore" when searching
  bool get hasMore => isSearching ? false : _hasMore;
  String? get error => _error;
  bool get hasProducts => products.isNotEmpty;
  
  bool get isSearching => _searchQuery.isNotEmpty;
  String get searchQuery => _searchQuery;

  // ─── Initialization ────────────────────────────────────────────────────────

  HomeProvider() {
    fetchInitialData();
  }

  /// Load the first page of products and all categories
  Future<void> fetchInitialData() async {
    if (_isLoadingInitial) return;

    _isLoadingInitial = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetchProducts(limit: _pageSize, offset: 0),
        _service.fetchCategories(),
      ]);

      _products = results[0] as List<Product>;
      _categories = results[1] as List<String>;
      _hasMore = _products.length >= _pageSize;
    } catch (e) {
      _error = e.toString();
      debugPrint('HomeProvider error: $_error');
    } finally {
      _isLoadingInitial = false;
      notifyListeners();
    }
  }

  /// Pull-to-refresh: reset and reload
  Future<void> refresh() async {
    _products = [];
    _hasMore = true;
    _error = null;
    await fetchInitialData();
  }

  /// Load the next page of products (infinite scroll)
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoadingInitial) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newProducts = await _service.fetchProducts(
        limit: _pageSize,
        offset: _products.length,
      );

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        // Avoid duplicates
        final existingIds = _products.map((p) => p.id).toSet();
        final unique = newProducts.where((p) => !existingIds.contains(p.id)).toList();
        _products.addAll(unique);
        _hasMore = newProducts.length >= _pageSize;
      }
    } catch (e) {
      debugPrint('HomeProvider loadMore error: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Filter by category (pass null to clear filter)
  Future<void> filterByCategory(String? category) async {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _products = [];
    _hasMore = true;
    _error = null;
    _isLoadingInitial = true;
    notifyListeners();

    try {
      if (category == null) {
        _products = await _service.fetchProducts(limit: _pageSize, offset: 0);
        _hasMore = _products.length >= _pageSize;
      } else {
        _products = await _service.fetchProductsByCategory(category);
        _hasMore = false; // FakeStore returns all items for a category
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingInitial = false;
      notifyListeners();
    }
  }

  /// Perform search on Title and Description
  Future<void> search(String query) async {
    _searchQuery = query.trim();
    if (_searchQuery.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoadingInitial = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await _service.searchProducts(_searchQuery);
    } catch (e) {
      _error = e.toString();
      debugPrint('HomeProvider search error: $_error');
    } finally {
      _isLoadingInitial = false;
      notifyListeners();
    }
  }
}
