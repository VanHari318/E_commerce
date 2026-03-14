// models/product.dart
// Product model matching FakeStore API response

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
  final String image;
  final ProductRating rating;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: ProductRating.fromJson(
        json['rating'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'category': category,
    'image': image,
    'rating': rating.toJson(),
  };

  /// Formatted price string (e.g. "$15.99")
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Simulated sold count string for display
  String get soldCount {
    final sold = (rating.count * 1.5).round();
    if (sold >= 1000) {
      return 'Đã bán ${(sold / 1000).toStringAsFixed(1)}k';
    }
    return 'Đã bán $sold';
  }

  /// Tag label based on rating
  String get tag {
    if (rating.rate >= 4.5) return 'Yêu thích';
    if (price < 20) return 'Giảm 50%';
    return 'Mall';
  }
}
