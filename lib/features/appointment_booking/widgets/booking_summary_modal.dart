import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/booking_state.dart';

/// Randevu Onay Özeti Modalı (SKILL.md: Seçimlerin özeti ve "Randevuyu Onayla" butonu)
class BookingSummaryModal extends StatelessWidget {
  final BookingState state;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const BookingSummaryModal({
    super.key,
    required this.state,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final hospital = state.selectedHospital!;
    final department = state.selectedDepartment!;
    final doctor = state.selectedDoctor!;
    final date = state.selectedDate!;
    final slot = state.selectedTimeSlot!;

    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Çekme Kulpu
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Başlık
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.assignment_turned_in_rounded,
                      color: AppColors.primaryLight, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Randevu Onay Özeti',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                color: AppColors.textMuted,
                onPressed: onCancel,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Özet Kartı
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  icon: Icons.local_hospital_rounded,
                  label: 'Sağlık Kuruluşu',
                  value: hospital.name,
                  subtitle: hospital.address,
                ),
                const Divider(color: AppColors.border, height: 20),
                _buildSummaryRow(
                  icon: department.icon,
                  label: 'Poliklinik / Bölüm',
                  value: department.name,
                ),
                const Divider(color: AppColors.border, height: 20),
                _buildSummaryRow(
                  icon: Icons.medical_services_rounded,
                  label: 'Muayene Eden Hekim',
                  value: doctor.fullTitleAndName,
                  subtitle: 'Puan: ★ ${doctor.rating} (${doctor.reviewCount} Yorum)',
                ),
                const Divider(color: AppColors.border, height: 20),
                _buildSummaryRow(
                  icon: Icons.calendar_month_rounded,
                  label: 'Randevu Zamanı',
                  value: '$formattedDate - Saat: ${slot.time}',
                  valueColor: AppColors.primaryLight,
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Güvenlik & SMS Bilgilendirme Notu
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primaryLight, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Randevu onayınız ve barkod numaranız kayıtlı cep telefonunuza SMS olarak iletilecektir.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // "Randevuyu Onayla" Butonu
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: state.isSubmitting ? null : onConfirm,
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 20, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Randevuyu Onayla',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.secondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
