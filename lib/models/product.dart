// models/product.dart
// Product model matching FakeStore API response

import 'package:intl/intl.dart';

class ProductRating {
  final double rate;
  final int count;

  const ProductRating({required this.rate, required this.count});

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() => {'rate': rate, 'count': count};
}

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final List<String> images;
  final ProductRating rating;
  final String tag;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.rating,
    required this.tag,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Determine images list, supporting both old String format and new List format
    List<String> imagesList = [];
    if (json['images'] is List) {
      imagesList = List<String>.from(json['images'] as List);
    } else if (json['images'] is String) {
      String imgsString = json['images'] as String;
      if (imgsString.contains(',')) {
        imagesList = imgsString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      } else {
        imagesList = [imgsString];
      }
    } else if (json['image'] is String) {
      imagesList = [json['image'] as String];
    }

    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      images: imagesList,
      rating: ProductRating.fromJson(
        json['rating'] as Map<String, dynamic>,
      ),
      tag: json['tag'] as String? ?? '', 
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'category': category,
    'images': images,
    'rating': rating.toJson(),
    'tag': tag,
  };

  /// Getter for backward compatibility or simple display
  String get image => images.isNotEmpty ? images.first : '';

  /// Formatted price string (e.g. "$15.99")
  String get formattedPrice => NumberFormat.simpleCurrency(locale: 'en_US').format(price);

  /// Formatted price in VND (approximate, using a static conversion rate)
  String get formattedPriceVnd {
    const rate = 23000; // 1 USD ~= 23,000 VND (approx)
    final vnd = (price * rate).round();
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);
    return fmt.format(vnd);
  }

  /// Simulated sold count string for display
  String get soldCount {
    final sold = (rating.count * 1.5).round();
    if (sold >= 1000) {
      return 'Đã bán ${(sold / 1000).toStringAsFixed(1)}k';
    }
    return 'Đã bán $sold';
  }
}
