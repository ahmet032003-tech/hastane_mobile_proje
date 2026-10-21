import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Radyoloji ve Tahliller Önizleme Sekmesi (SKILL.md 1.6)
class PatientMedicalTestsTab extends StatelessWidget {
  const PatientMedicalTestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Radyoloji & Tahliller',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'En Yeniden En Eskiye',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTestCard(
          category: 'Laboratuvar',
          testName: 'Hemogram & Biyokimya Paneli',
          doctor: 'Doç. Dr. Emre Çetin',
          date: '12 Ekim 2026',
          status: 'Sonuçlandı (Normal)',
          isRadiology: false,
        ),
        const SizedBox(height: 12),
        _buildTestCard(
          category: 'Radyoloji',
          testName: 'Akciğer PA Grafisi (Röntgen)',
          doctor: 'Uzm. Dr. Selin Kaya',
          date: '04 Eylül 2026',
          status: 'Rapor Onaylandı',
          isRadiology: true,
        ),
        const SizedBox(height: 12),
        _buildTestCard(
          category: 'Kardiyoloji',
          testName: 'Ekokardiyografi (EKO)',
          doctor: 'Doç. Dr. Emre Çetin',
          date: '15 Temmuz 2026',
          status: 'Rapor Onaylandı',
          isRadiology: true,
        ),
      ],
    );
  }

  Widget _buildTestCard({
    required String category,
    required String testName,
    required String doctor,
    required String date,
    required String status,
    required bool isRadiology,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isRadiology
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.accentTeal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isRadiology
                          ? Icons.camera_alt_outlined
                          : Icons.science_outlined,
                      color: isRadiology
                          ? AppColors.primaryLight
                          : AppColors.accentTeal,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          color: isRadiology
                              ? AppColors.primaryLight
                              : AppColors.accentTeal,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        testName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'İstem: $doctor',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              Text(
                date,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: AppColors.success,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
