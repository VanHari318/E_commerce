// screens/home_screen.dart
// TH4 - Nhóm 11 — Màn Hình 1: Trang Chủ
//
// Features:
//  • SliverAppBar with sticky + color-changing search bar on scroll
//  • Cart icon with live badge
//  • Auto-play banner carousel with dot indicator
//  • Horizontal category strip (with filter)
//  • 2-column product GridView with shimmer loading
//  • Pull-to-Refresh
//  • Infinite Scroll (pagination)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/cart_badge_icon.dart';
import '../widgets/category_row.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import 'product_detail_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchBarSticky = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Detect when user has scrolled past ~80px to make search sticky + change colour
    final shouldBeSticky = _scrollController.offset > 80;
    if (shouldBeSticky != _isSearchBarSticky) {
      setState(() => _isSearchBarSticky = shouldBeSticky);
    }

    // Infinite scroll trigger — load more when within 300px of bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<HomeProvider>().loadMore();
    }
  }

  Future<void> _onRefresh() async {
    _searchController.clear();
    await context.read<HomeProvider>().refresh();
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: primaryColor,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── SliverAppBar ──────────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: 130,
              backgroundColor: _isSearchBarSticky ? primaryColor : primaryColor,
              elevation: _isSearchBarSticky ? 4 : 0,
              // Cart icon with live badge
              actions: [
                IconButton(
                  icon: const Icon(Icons.history, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                    );
                  },
                ),
                CartBadgeIcon(onTap: _navigateToCart),
              ],

              // Flexible space containing app title + search bar
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 72, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          const Text(
                            'TH4 - Nhóm 11',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Search bar
                          _SearchBar(isSticky: _isSearchBarSticky, controller: _searchController),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Sticky search bar shown in title area when collapsed
              title: _isSearchBarSticky
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _SearchBar(isSticky: true, controller: _searchController),
                    )
                  : null,
            ),

            // ── Body Content ──────────────────────────────────────────────
            Consumer<HomeProvider>(
              builder: (context, home, child) {
                // If searching, hide the banners and categories
                if (home.isSearching || home.searchQuery.isNotEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 20, bottom: 10),
                      child: Text(
                        'Kết quả tìm kiếm cho "${home.searchQuery}"',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  );
                }

                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const SizedBox(height: 12),
                  // Banner Carousel
                  const BannerCarousel(),
                  const SizedBox(height: 16),
                  // Categories
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                      'Danh Mục',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  const CategoryRow(),
                  const SizedBox(height: 16),
                  // Section title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Gợi Ý Hôm Nay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.local_fire_department,
                            color: Colors.orange.shade600, size: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),

        // ── Product Grid ──────────────────────────────────────────────
            Consumer<HomeProvider>(
              builder: (context, home, _) {
                if (home.isLoadingInitial) {
                  // Show shimmer grid while loading
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (_, __) => const ProductCardShimmer(),
                        childCount: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.60,
                      ),
                    ),
                  );
                }

                if (home.error != null && !home.hasProducts) {
                  return SliverToBoxAdapter(
                    child: _ErrorWidget(
                      message: home.error!,
                      onRetry: home.fetchInitialData,
                    ),
                  );
                }

                if (home.isSearching && !home.hasProducts) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'Không tìm thấy sản phẩm nào phù hợp.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = home.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
                        );
                      },
                      childCount: home.products.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.60,
                    ),
                  ),
                );
              },
            ),

            // ── Infinite Scroll Footer ─────────────────────────────────────
            Consumer<HomeProvider>(
              builder: (context, home, _) {
                if (home.isLoadingMore) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  );
                }
                if (!home.hasMore && home.hasProducts) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          '— Đã hiển thị tất cả sản phẩm —',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox(height: 20));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Search Bar ─────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final bool isSticky;
  final TextEditingController controller;

  const _SearchBar({required this.isSticky, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 38,
      decoration: BoxDecoration(
        color: isSticky
            ? Colors.white.withOpacity(0.2)
            : Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: isSticky
            ? Border.all(color: Colors.white.withOpacity(0.5))
            : null,
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          context.read<HomeProvider>().search(value);
        },
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: 13,
          color: isSticky ? Colors.white : Colors.grey.shade800,
        ),
        decoration: InputDecoration(
          hintText: 'Tìm kiếm sản phẩm...',
          hintStyle: TextStyle(
            fontSize: 13,
            color: isSticky ? Colors.white70 : Colors.grey.shade500,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 18,
            color: isSticky ? Colors.white70 : Colors.grey.shade500,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(Icons.clear, size: 16, color: isSticky ? Colors.white70 : Colors.grey.shade500),
                onPressed: () {
                  controller.clear();
                  context.read<HomeProvider>().search('');
                },
              );
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          isDense: true,
        ),
      ),
    );
  }
}

// ─── Error Widget ─────────────────────────────────────────────────────────────

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Không thể tải sản phẩm',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
