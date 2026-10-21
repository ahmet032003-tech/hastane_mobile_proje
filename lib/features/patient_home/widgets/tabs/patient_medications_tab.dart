import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// İlaçlar ve Reçeteler Önizleme Sekmesi (SKILL.md 1.5)
class PatientMedicationsTab extends StatelessWidget {
  const PatientMedicationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Aktif İlaçlar & Reçeteler',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'En Yeniden En Eskiye',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildMedicationCard(
          medicineName: 'Kopidogrel 75 mg',
          purpose: 'Kardiyovasküler Koruma',
          doctor: 'Doç. Dr. Emre Çetin (Kardiyoloji)',
          dosage: 'Günde 1 Defa (Tok)',
          expireDate: '10.11.2026',
        ),
        const SizedBox(height: 12),
        _buildMedicationCard(
          medicineName: 'Ventolin İnhaler 100 mcg',
          purpose: 'Alerjik Astım / Nefes Darlığı',
          doctor: 'Uzm. Dr. Selin Kaya (Göğüs Hastalıkları)',
          dosage: 'Gerektiğinde 2 Doz',
          expireDate: '15.01.2027',
        ),
        const SizedBox(height: 12),
        _buildMedicationCard(
          medicineName: 'Benexol B12',
          purpose: 'B12 Vitamini Desteği',
          doctor: 'Uzm. Dr. Murat Demir (İç Hastalıkları)',
          dosage: 'Günde 1 Tablet (Sabah Tok)',
          expireDate: '22.04.2027',
        ),
      ],
    );
  }

  Widget _buildMedicationCard({
    required String medicineName,
    required String purpose,
    required String doctor,
    required String dosage,
    required String expireDate,
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
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.medication_liquid_rounded,
                      color: AppColors.primaryLight,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    medicineName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tanı: $purpose',
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hekim: $doctor',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'Kullanım: $dosage',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Son Kullanım: $expireDate',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
