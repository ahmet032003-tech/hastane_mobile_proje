import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Doktor Dashboard Üst Bölümü
/// Hekim görseli, unvan, ad-soyad, poliklinik adı ve muayene durumu anahtarı (Açık/Mola)
class DoctorDashboardHeader extends StatelessWidget {
  final String fullDoctorName;
  final String clinicName;
  final bool isExamOpen;
  final ValueChanged<bool> onExamStatusChanged;

  const DoctorDashboardHeader({
    super.key,
    required this.fullDoctorName,
    required this.clinicName,
    required this.isExamOpen,
    required this.onExamStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Hekim Görseli / Avatarı
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'EÇ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Unvan, Ad-Soyad ve Poliklinik Adı
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullDoctorName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.meeting_room_outlined,
                          size: 14,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            clinicName,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),

          // Muayene Durumu Anahtarı (Açık / Mola)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isExamOpen ? AppColors.success : AppColors.warning,
                      boxShadow: [
                        BoxShadow(
                          color: (isExamOpen
                                  ? AppColors.success
                                  : AppColors.warning)
                              .withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isExamOpen ? 'Poliklinik Muayenesi: AÇIK' : 'Poliklinik: MOLA MODUNDA',
                    style: TextStyle(
                      color: isExamOpen ? AppColors.success : AppColors.warning,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    isExamOpen ? 'Açık' : 'Mola',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Switch(
                    value: isExamOpen,
                    activeTrackColor: AppColors.success,
                    activeThumbColor: Colors.white,
                    inactiveTrackColor: AppColors.surfaceSecondary,
                    inactiveThumbColor: AppColors.textMuted,
                    onChanged: onExamStatusChanged,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
