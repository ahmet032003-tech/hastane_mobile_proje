import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Randevu Listesi Sekmesi (SKILL.md 2.3: Günlük saatlik hasta akışı)
class DoctorAppointmentsTab extends StatelessWidget {
  const DoctorAppointmentsTab({super.key});

  static const List<Map<String, dynamic>> _appointments = [
    {
      'time': '09:00',
      'patient': 'Mehmet Özdemir',
      'complaint': 'Rutin EKG kontrolü',
      'status': 'Tamamlandı',
      'isCompleted': true,
    },
    {
      'time': '09:30',
      'patient': 'Ayşe Yılmaz',
      'complaint': 'Hipertansiyon ve baş dönmesi',
      'status': 'Tamamlandı',
      'isCompleted': true,
    },
    {
      'time': '10:15',
      'patient': 'Ahmet Demir',
      'complaint': 'Göğüs ağrısı ve çarpıntı',
      'status': 'Tamamlandı',
      'isCompleted': true,
    },
    {
      'time': '14:15',
      'patient': 'Fatma Şahin',
      'complaint': 'Göğüste sıkışma hissi, efor dispnesi',
      'status': 'Muayene Odasında',
      'isActive': true,
    },
    {
      'time': '14:45',
      'patient': 'Hasan Yurtseven',
      'complaint': 'İlaç raporu yenileme',
      'status': 'Kapıda Bekliyor',
      'isWaiting': true,
    },
    {
      'time': '15:15',
      'patient': 'Zeynep Kaya',
      'complaint': 'Efor testi değerlendirmesi',
      'status': 'Sırada',
      'isWaiting': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Günlük Hasta Akışı',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Bugün • 24 Randevu',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        ..._appointments.map((item) {
          final isCompleted = item['isCompleted'] == true;
          final isActive = item['isActive'] == true;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isActive
                    ? AppColors.primaryLight
                    : AppColors.border,
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                // Saat Rozeti
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.success.withValues(alpha: 0.15)
                        : (isActive
                            ? AppColors.primary
                            : AppColors.surfaceSecondary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item['time'] as String,
                    style: TextStyle(
                      color: isCompleted
                          ? AppColors.success
                          : (isActive ? Colors.white : AppColors.textPrimary),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Hasta Bilgileri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['patient'] as String,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['complaint'] as String,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Durum Etiketi
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.success.withValues(alpha: 0.15)
                        : (isActive
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : AppColors.warning.withValues(alpha: 0.15)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['status'] as String,
                    style: TextStyle(
                      color: isCompleted
                          ? AppColors.success
                          : (isActive
                              ? AppColors.primaryLight
                              : AppColors.warning),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
