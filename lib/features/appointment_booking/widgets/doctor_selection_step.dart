import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/department_model.dart';
import '../models/doctor_model.dart';

/// 3. Adım: İlgili branştaki hekimler (fotoğraf, unvan, değerlendirme puanı)
class DoctorSelectionStep extends StatelessWidget {
  final DepartmentModel department;
  final List<DoctorModel> doctors;
  final DoctorModel? selectedDoctor;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<DoctorModel> onDoctorSelected;

  const DoctorSelectionStep({
    super.key,
    required this.department,
    required this.doctors,
    required this.selectedDoctor,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onDoctorSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Seçilen poliklinikteki hekimleri filtrele
    final deptDoctors = doctors.where((d) {
      final matchesDept = d.departmentId == department.id;
      final query = searchQuery.trim().toLowerCase();
      if (query.isEmpty) return matchesDept;
      return matchesDept &&
          (d.name.toLowerCase().contains(query) ||
              d.title.toLowerCase().contains(query));
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Seçilen Poliklinik Rozeti
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(department.icon, color: AppColors.primaryLight, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${department.name} Hekimleri',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Arama Alanı
        TextField(
          onChanged: onSearchChanged,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Hekim adı veya unvanı ara...',
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
              'Müsait Hekimler',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${deptDoctors.length} Doktor',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (deptDoctors.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Text(
                'Bu branşta aradığınız kriterlere uygun hekim bulunamadı.',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: deptDoctors.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doctor = deptDoctors[index];
              final isSelected = selectedDoctor?.id == doctor.id;

              return InkWell(
                onTap: () => onDoctorSelected(doctor),
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
                      // Doktor Fotoğrafı / Avatarı
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryLight
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            doctor.avatarInitials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Unvan, İsim, Değerlendirme Puanı
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  doctor.title,
                                  style: const TextStyle(
                                    color: AppColors.primaryLight,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '• ${doctor.experienceYears} Yıl Deneyim',
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              doctor.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Değerlendirme Puanı & Yorum Sayısı
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.warning,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${doctor.rating}',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${doctor.reviewCount} Değerlendirme)',
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

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
