import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../doctor_auth/views/doctor_login_view.dart';

/// Doktor Profili Sekmesi (SKILL.md 2.3: Çalışma takvimi ve slot yönetimi)
class DoctorProfileTab extends StatefulWidget {
  final String doctorName;
  final String clinicName;

  const DoctorProfileTab({
    super.key,
    required this.doctorName,
    required this.clinicName,
  });

  @override
  State<DoctorProfileTab> createState() => _DoctorProfileTabState();
}

class _DoctorProfileTabState extends State<DoctorProfileTab> {
  int _slotDurationMinutes = 15;
  bool _morningSlotsActive = true;
  bool _afternoonSlotsActive = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // Hekim Başlık Kartı
        Center(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'EÇ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.doctorName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.clinicName,
                style: const TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tescil No: 123456 • Kurum: Acil Şifa Hastanesi (ASH-34)',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Çalışma Takvimi & Slot Yönetimi Kartı
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_month_rounded,
                      color: AppColors.primaryLight, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Çalışma Takvimi & Slot Yönetimi',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Muayene Süresi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hasta Başı Slot Süresi',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  DropdownButton<int>(
                    value: _slotDurationMinutes,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.bold),
                    items: const [
                      DropdownMenuItem(value: 10, child: Text('10 Dakika')),
                      DropdownMenuItem(value: 15, child: Text('15 Dakika')),
                      DropdownMenuItem(value: 20, child: Text('20 Dakika')),
                      DropdownMenuItem(value: 30, child: Text('30 Dakika')),
                    ],
                    onChanged: (v) =>
                        setState(() => _slotDurationMinutes = v!),
                  ),
                ],
              ),
              const Divider(color: AppColors.border, height: 16),

              // Sabah Slotları Durumu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sabah Slotları (09:00 - 12:00)',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                  Switch(
                    value: _morningSlotsActive,
                    activeTrackColor: AppColors.primary,
                    onChanged: (v) => setState(() => _morningSlotsActive = v),
                  ),
                ],
              ),
              const Divider(color: AppColors.border, height: 8),

              // Öğle Slotları Durumu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Öğleden Sonra Slotları (13:30 - 17:00)',
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                  Switch(
                    value: _afternoonSlotsActive,
                    activeTrackColor: AppColors.primary,
                    onChanged: (v) => setState(() => _afternoonSlotsActive = v),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Çıkış Yap Butonu
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
            label: const Text(
              'Hekim Oturumunu Kapat',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (_) => const DoctorLoginView(),
                ),
                (route) => false,
              );
            },
          ),
        ),
      ],
    );
  }
}
