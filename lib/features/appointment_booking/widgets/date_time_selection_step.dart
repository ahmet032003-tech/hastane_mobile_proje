import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/doctor_model.dart';
import '../models/time_slot_model.dart';

/// 4. Adım: Gün seçici ve sabah/öğle saat slotları (dolu saatler pasif)
class DateTimeSelectionStep extends StatelessWidget {
  final DoctorModel doctor;
  final DateTime? selectedDate;
  final TimeSlotModel? selectedTimeSlot;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<TimeSlotModel> onTimeSlotSelected;

  const DateTimeSelectionStep({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.onDateSelected,
    required this.onTimeSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Önümüzdeki 7 günlük tarih listesi
    final today = DateTime.now();
    final availableDates = List.generate(7, (i) => today.add(Duration(days: i)));

    final morningSlots = TimeSlotModel.mockMorningSlots();
    final afternoonSlots = TimeSlotModel.mockAfternoonSlots();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Seçilen Doktor Bilgi Rozeti
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.person_pin_rounded,
                  color: AppColors.primaryLight, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${doctor.fullTitleAndName} - Müsaitlik Takvimi',
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
        const SizedBox(height: 20),

        // 1. Gün Seçici Başlığı
        const Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                color: AppColors.primaryLight, size: 16),
            SizedBox(width: 8),
            Text(
              'Randevu Tarihi Seçin',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Yatay Gün Seçici
        SizedBox(
          height: 98,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableDates.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final date = availableDates[index];
              final isSelected = selectedDate != null &&
                  selectedDate!.year == date.year &&
                  selectedDate!.month == date.month &&
                  selectedDate!.day == date.day;

              final isToday = index == 0;
              final dayName = _getDayName(date.weekday);
              final monthName = _getMonthName(date.month);

              return InkWell(
                onTap: () => onDateSelected(date),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 68,
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isToday ? 'Bugün' : dayName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        monthName,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // 2. Sabah Saat Slotları
        const Row(
          children: [
            Icon(Icons.wb_sunny_outlined,
                color: AppColors.warning, size: 16),
            SizedBox(width: 8),
            Text(
              'Sabah Slotları',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSlotGrid(morningSlots),
        const SizedBox(height: 20),

        // 3. Öğle / Öğleden Sonra Saat Slotları
        const Row(
          children: [
            Icon(Icons.wb_twilight_rounded,
                color: AppColors.secondary, size: 16),
            SizedBox(width: 8),
            Text(
              'Öğleden Sonra Slotları',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSlotGrid(afternoonSlots),
        const SizedBox(height: 16),

        // Dolu ve Boş Lejantı
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend(color: AppColors.card, label: 'Müsait', hasBorder: true),
            const SizedBox(width: 16),
            _buildLegend(color: AppColors.primary, label: 'Seçili'),
            const SizedBox(width: 16),
            _buildLegend(
              color: AppColors.surfaceSecondary.withValues(alpha: 0.5),
              label: 'Dolu (Pasif)',
              isPassive: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSlotGrid(List<TimeSlotModel> slots) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((slot) {
        final isSelected = selectedTimeSlot?.time == slot.time;
        final isBooked = slot.isBooked;

        return InkWell(
          onTap: isBooked ? null : () => onTimeSlotSelected(slot),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isBooked
                  ? AppColors.surfaceSecondary.withValues(alpha: 0.4)
                  : (isSelected
                      ? AppColors.primary
                      : AppColors.card),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isBooked
                    ? AppColors.border.withValues(alpha: 0.3)
                    : (isSelected
                        ? AppColors.primaryLight
                        : AppColors.border),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isBooked
                      ? Icons.block_rounded
                      : (isSelected
                          ? Icons.access_time_filled_rounded
                          : Icons.access_time_rounded),
                  size: 14,
                  color: isBooked
                      ? AppColors.textMuted.withValues(alpha: 0.5)
                      : (isSelected ? Colors.white : AppColors.secondary),
                ),
                const SizedBox(width: 6),
                Text(
                  slot.time,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isBooked
                        ? AppColors.textMuted.withValues(alpha: 0.5)
                        : (isSelected ? Colors.white : AppColors.textPrimary),
                    decoration: isBooked ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (isBooked) ...[
                  const SizedBox(width: 6),
                  Text(
                    'Dolu',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLegend({
    required Color color,
    required String label,
    bool hasBorder = false,
    bool isPassive = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: hasBorder ? Border.all(color: AppColors.border) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isPassive ? AppColors.textMuted : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Pzt';
      case 2:
        return 'Sal';
      case 3:
        return 'Çar';
      case 4:
        return 'Per';
      case 5:
        return 'Cum';
      case 6:
        return 'Cmt';
      case 7:
        return 'Paz';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    return months[month - 1];
  }
}
