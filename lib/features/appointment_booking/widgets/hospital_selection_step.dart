import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/hospital_model.dart';

/// 1. Adım: Arama ve mesafe bilgili hastane listesi
class HospitalSelectionStep extends StatelessWidget {
  final List<HospitalModel> hospitals;
  final HospitalModel? selectedHospital;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<HospitalModel> onHospitalSelected;

  const HospitalSelectionStep({
    super.key,
    required this.hospitals,
    required this.selectedHospital,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onHospitalSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = hospitals.where((h) {
      final query = searchQuery.trim().toLowerCase();
      if (query.isEmpty) return true;
      return h.name.toLowerCase().contains(query) ||
          h.address.toLowerCase().contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Arama Alanı
        TextField(
          onChanged: onSearchChanged,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Hastane adı veya ilçe ile arayın...',
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
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'En Yakın Sağlık Kuruluşları',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${filtered.length} Hastane',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (filtered.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Column(
                children: [
                  const Icon(Icons.location_off_rounded,
                      size: 40, color: AppColors.textMuted),
                  const SizedBox(height: 10),
                  Text(
                    '"$searchQuery" ile eşleşen hastane bulunamadı.',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final hospital = filtered[index];
              final isSelected = selectedHospital?.id == hospital.id;

              return InkWell(
                onTap: () => onHospitalSelected(hospital),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Hastane İkon Rozeti
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryLight
                                : AppColors.border,
                          ),
                        ),
                        child: Icon(
                          Icons.local_hospital_rounded,
                          color: isSelected
                              ? AppColors.primaryLight
                              : AppColors.secondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Hastane Detayları
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hospital.name,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primaryLight
                                    : AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hospital.address,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Mesafe ve Puan Etiketleri
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceSecondary,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.near_me_rounded,
                                        size: 12,
                                        color: AppColors.primaryLight,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${hospital.distanceKm} km mesafede',
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.warning.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 13,
                                        color: AppColors.warning,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${hospital.rating}',
                                        style: const TextStyle(
                                          color: AppColors.warning,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Seçim İkonu
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? AppColors.primaryLight
                            : AppColors.textMuted,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
