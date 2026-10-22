import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/doctor_dashboard_state.dart';

/// Randevu Listesi Sekmesi (SKILL.md 2.3: Günlük saatlik hasta akışı)
class DoctorAppointmentsTab extends StatelessWidget {
  final List<DoctorPatientAppointment>? appointments;

  const DoctorAppointmentsTab({
    super.key,
    this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    final list = appointments ?? DoctorDashboardState.defaultAppointments;
    final allCompleted = list.every((item) => item.isCompleted);

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
                color: allCompleted
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                allCompleted ? 'Bugün • Tümü Tamamlandı' : 'Bugün • 24 Randevu',
                style: TextStyle(
                  color: allCompleted
                      ? AppColors.success
                      : AppColors.primaryLight,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...list.map((item) {
          final isCompleted = item.isCompleted;
          final isActive = item.isActive;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isActive ? AppColors.primaryLight : AppColors.border,
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
                    item.appointmentTime,
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
                        item.patientName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.complaint,
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
                    item.status,
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
