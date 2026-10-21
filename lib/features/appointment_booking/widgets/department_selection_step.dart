import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/department_model.dart';
import '../models/hospital_model.dart';

/// 2. Adım: Seçilen hastaneye ait poliklinikler
class DepartmentSelectionStep extends StatelessWidget {
  final HospitalModel hospital;
  final List<DepartmentModel> departments;
  final DepartmentModel? selectedDepartment;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<DepartmentModel> onDepartmentSelected;

  const DepartmentSelectionStep({
    super.key,
    required this.hospital,
    required this.departments,
    required this.selectedDepartment,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onDepartmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Seçilen hastanede hizmet veren poliklinikleri filtrele
    final hospitalClinics = departments.where((d) {
      final matchesHospital = d.hospitalIds.contains(hospital.id);
      final query = searchQuery.trim().toLowerCase();
      if (query.isEmpty) return matchesHospital;
      return matchesHospital && d.name.toLowerCase().contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Seçilen Hastane Bilgi Rozeti
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hospital.name,
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
            hintText: 'Poliklinik veya uzmanlık alanı ara...',
            prefixIcon: const Icon(Icons.search_rounded,
                color: AppColors.secondary, size: 20),
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
              'Mevcut Poliklinikler',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${hospitalClinics.length} Bölüm',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (hospitalClinics.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Text(
                '"$searchQuery" polikliniği bu hastanede bulunamadı.',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: hospitalClinics.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final dept = hospitalClinics[index];
              final isSelected = selectedDepartment?.id == dept.id;

              return InkWell(
                onTap: () => onDepartmentSelected(dept),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          dept.icon,
                          color: isSelected
                              ? AppColors.primaryLight
                              : AppColors.secondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          dept.name,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primaryLight
                                : AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? AppColors.primaryLight
                            : AppColors.textMuted,
                        size: 20,
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
