import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/medical_test_model.dart';

/// Radyoloji ve Tahliller Filtreleme ve Arama Barı
class MedicalTestFiltersBar extends StatelessWidget {
  final String searchQuery;
  final bool isSortDescending;
  final TestCategory? selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onToggleSort;
  final ValueChanged<TestCategory?> onCategorySelected;

  const MedicalTestFiltersBar({
    super.key,
    required this.searchQuery,
    required this.isSortDescending,
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onToggleSort,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Arama ve Sıralama
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onSearchChanged,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Tetkik adı, hekim veya tanı ara...',
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.primaryLight, size: 20),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => onSearchChanged(''),
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Sıralama Butonu
            InkWell(
              onTap: onToggleSort,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSortDescending
                        ? AppColors.primaryLight
                        : AppColors.secondary,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSortDescending
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      size: 16,
                      color: isSortDescending
                          ? AppColors.primaryLight
                          : AppColors.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isSortDescending ? 'En Yeni' : 'En Eski',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSortDescending
                            ? AppColors.primaryLight
                            : AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Kategori Chipleri
        Row(
          children: [
            _buildCategoryChip(
              label: 'Tüm Tetkikler',
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
            ),
            const SizedBox(width: 8),
            _buildCategoryChip(
              label: 'Radyoloji',
              icon: Icons.camera_alt_outlined,
              isSelected: selectedCategory == TestCategory.radiology,
              onTap: () => onCategorySelected(TestCategory.radiology),
            ),
            const SizedBox(width: 8),
            _buildCategoryChip(
              label: 'Laboratuvar',
              icon: Icons.science_outlined,
              isSelected: selectedCategory == TestCategory.laboratory,
              onTap: () => onCategorySelected(TestCategory.laboratory),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color:
                    isSelected ? AppColors.primaryLight : AppColors.textMuted,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color:
                    isSelected ? AppColors.primaryLight : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
