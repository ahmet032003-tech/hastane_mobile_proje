import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// İlaç Arama, Sıralama, Durum (Aktif/Geçmiş) ve Hastalık Filtre Barı
class MedicationFiltersBar extends StatelessWidget {
  final String searchQuery;
  final bool isSortDescending;
  final List<String> availableDiseases;
  final String? selectedDiseaseFilter;
  final bool? activeFilter;
  final int activeCount;
  final int pastCount;
  final int totalCount;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onToggleSort;
  final ValueChanged<String?> onDiseaseSelected;
  final ValueChanged<bool?> onStatusSelected;

  const MedicationFiltersBar({
    super.key,
    required this.searchQuery,
    required this.isSortDescending,
    required this.availableDiseases,
    required this.selectedDiseaseFilter,
    this.activeFilter,
    this.activeCount = 3,
    this.pastCount = 2,
    this.totalCount = 5,
    required this.onSearchChanged,
    required this.onToggleSort,
    required this.onDiseaseSelected,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Arama ve Sıralama Satırı
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onSearchChanged,
                style:
                    const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'İlaç adı, hekim veya tanı ara...',
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
            // Sıralama Değiştirme Butonu
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

        // 2. Aktif / Geçmiş Durum Filtre Tabları (Kullanıcının talep ettiği ana ayrım)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _buildStatusSegment(
                label: 'Tümü ($totalCount)',
                isSelected: activeFilter == null,
                onTap: () => onStatusSelected(null),
              ),
              _buildStatusSegment(
                label: 'Aktif İlaçlar ($activeCount)',
                isSelected: activeFilter == true,
                badgeColor: AppColors.success,
                onTap: () => onStatusSelected(true),
              ),
              _buildStatusSegment(
                label: 'Geçmiş ($pastCount)',
                isSelected: activeFilter == false,
                onTap: () => onStatusSelected(false),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 3. Hastalık / Tanı Filtre Chipleri
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // "Tümü" Filtresi
              _buildFilterChip(
                label: 'Tümü',
                isSelected: selectedDiseaseFilter == null,
                onTap: () => onDiseaseSelected(null),
              ),
              const SizedBox(width: 8),

              // Hastalık Chipleri
              ...availableDiseases.map((disease) {
                final isSelected = selectedDiseaseFilter == disease;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildFilterChip(
                    label: disease,
                    isSelected: isSelected,
                    onTap: () => onDiseaseSelected(disease),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSegment({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? badgeColor,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? (badgeColor != null
                    ? badgeColor.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.3))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(
                    color: badgeColor ?? AppColors.primaryLight,
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (badgeColor != null) ...[
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? (badgeColor ?? AppColors.primaryLight)
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
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
              ? AppColors.primary
              : AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryLight
                : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
