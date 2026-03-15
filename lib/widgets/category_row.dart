// widgets/category_row.dart
// Horizontal scrollable category strip with icons

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';

// Map category API names → display name + icon
const _categoryMeta = {
  'electronics': (label: 'Điện Tử', icon: Icons.devices),
  "men's clothing": (label: 'Nam', icon: Icons.man),
  "women's clothing": (label: 'Nữ', icon: Icons.woman),
  'jewelery': (label: 'Trang Sức', icon: Icons.diamond),
};

// Extra local display categories (not from API, just visual)
const _extraCategories = [
  (id: 'cosmetics', label: 'Mỹ Phẩm', icon: Icons.face_retouching_natural),
  (id: 'home', label: 'Gia Dụng', icon: Icons.home),
  (id: 'food', label: 'Thực Phẩm', icon: Icons.fastfood),
  (id: 'sport', label: 'Thể Thao', icon: Icons.sports_soccer),
];

class CategoryRow extends StatelessWidget {
  const CategoryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, home, _) {
        final apiCategories = home.categories;
        final selectedCategory = home.selectedCategory;
        final theme = Theme.of(context);

        return SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              // "Tất cả" chip – clears category filter
              _CategoryChip(
                icon: Icons.grid_view_rounded,
                label: 'Tất Cả',
                isSelected: selectedCategory == null,
                onTap: () => home.filterByCategory(null),
                color: theme.colorScheme.primary,
              ),
              // API-sourced categories
              ...apiCategories.map((cat) {
                final meta = _categoryMeta[cat];
                return _CategoryChip(
                  icon: meta?.icon ?? Icons.category,
                  label: meta?.label ?? _capitalize(cat),
                  isSelected: selectedCategory == cat,
                  onTap: () => home.filterByCategory(cat),
                  color: theme.colorScheme.primary,
                );
              }),
              // Extra visual categories
              ..._extraCategories.map((cat) {
                return _CategoryChip(
                  icon: cat.icon,
                  label: cat.label,
                  isSelected: false,
                  onTap: () {}, // Not filterable (no API endpoint)
                  color: Colors.grey.shade600,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _CategoryChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.15)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(color: color, width: 2)
                    : Border.all(color: Colors.transparent),
                boxShadow: isSelected
                    ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 6)]
                    : [],
              ),
              child: Icon(icon, size: 26, color: isSelected ? color : Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
