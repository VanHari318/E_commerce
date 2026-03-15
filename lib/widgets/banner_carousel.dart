// widgets/banner_carousel.dart
// Auto-play promotional banner carousel with dot indicator

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  // Promotional banners using picsum for reliable network images
  static const List<_BannerData> _banners = [
    _BannerData(
      imageUrl: 'https://picsum.photos/seed/sale1/800/300',
      label: '🔥 Siêu Sale 6.6 – Giảm đến 70%',
      gradient: [Color(0xFFFF5722), Color(0xFFFF9800)],
    ),
    _BannerData(
      imageUrl: 'https://picsum.photos/seed/fashion2/800/300',
      label: '👗 Thời Trang Hè – Miễn ship toàn quốc',
      gradient: [Color(0xFF9C27B0), Color(0xFFE91E63)],
    ),
    _BannerData(
      imageUrl: 'https://picsum.photos/seed/tech3/800/300',
      label: '📱 Điện Tử – Trả góp 0%',
      gradient: [Color(0xFF1565C0), Color(0xFF00BCD4)],
    ),
    _BannerData(
      imageUrl: 'https://picsum.photos/seed/flash4/800/300',
      label: '⚡ Flash Sale – Chỉ hôm nay',
      gradient: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 160,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            viewportFraction: 0.92,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          items: _banners.map((banner) => _BannerItem(banner: banner)).toList(),
        ),
        const SizedBox(height: 8),
        // Dot indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BannerData {
  final String imageUrl;
  final String label;
  final List<Color> gradient;

  const _BannerData({
    required this.imageUrl,
    required this.label,
    required this.gradient,
  });
}

class _BannerItem extends StatelessWidget {
  final _BannerData banner;

  const _BannerItem({required this.banner});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient fallback
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: banner.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Network image with fade-in
          Image.network(
            banner.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (ctx, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(); // show gradient while loading
            },
            errorBuilder: (ctx, error, stack) => Container(), // keep gradient
          ),
          // Dark overlay for text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Label text
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Text(
              banner.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
