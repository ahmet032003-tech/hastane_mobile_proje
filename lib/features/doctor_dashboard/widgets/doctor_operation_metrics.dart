import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Doktor Poliklinik Masası Operasyon Metrikleri (SKILL.md 2.2)
/// Günlük toplam randevu, tamamlanan muayene, bekleyen hasta sayısı
class DoctorOperationMetrics extends StatelessWidget {
  final int totalAppointments;
  final int completedExaminations;
  final int waitingPatients;

  const DoctorOperationMetrics({
    super.key,
    required this.totalAppointments,
    required this.completedExaminations,
    required this.waitingPatients,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.query_stats_rounded,
                color: AppColors.primaryLight, size: 18),
            SizedBox(width: 8),
            Text(
              'Günlük Operasyon Metrikleri',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // 1. Günlük Toplam Randevu
            Expanded(
              child: _MetricItem(
                title: 'Toplam Randevu',
                value: '$totalAppointments',
                unit: 'Randevu',
                icon: Icons.calendar_month_rounded,
                accentColor: AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: 10),

            // 2. Tamamlanan Muayene
            Expanded(
              child: _MetricItem(
                title: 'Tamamlanan',
                value: '$completedExaminations',
                unit: 'Muayene',
                icon: Icons.check_circle_outline_rounded,
                accentColor: AppColors.success,
              ),
            ),
            const SizedBox(width: 10),

            // 3. Bekleyen Hasta Sayısı
            Expanded(
              child: _MetricItem(
                title: 'Bekleyen Hasta',
                value: '$waitingPatients',
                unit: 'Sırada',
                icon: Icons.hourglass_top_rounded,
                accentColor: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color accentColor;

  const _MetricItem({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: accentColor),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              color: accentColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
