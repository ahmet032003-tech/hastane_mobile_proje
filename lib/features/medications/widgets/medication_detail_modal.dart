import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/medication_model.dart';

/// İlaç Detay Kartı (SKILL.md: İlacı yazan hekim, yazılma gerekçesi, son kullanım tarihi, kullanım talimatı ve güncel/geçmiş durum)
class MedicationDetailModal extends StatelessWidget {
  final MedicationModel medication;

  const MedicationDetailModal({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = medication.isActive;

    return SingleChildScrollView(
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
          const SizedBox(height: 18),

          // İlaç Adı ve Kapatma Butonu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isActive
                            ? Icons.medication_liquid_rounded
                            : Icons.medication_rounded,
                        color: isActive
                            ? AppColors.primaryLight
                            : AppColors.textMuted,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medication.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Kutu Adedi: ${medication.boxCount} Kutu',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                color: AppColors.textMuted,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Aktif / Geçmiş İlaç Durum Bilgilendirme Rozeti
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.success.withValues(alpha: 0.15)
                  : AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? AppColors.success.withValues(alpha: 0.45)
                    : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isActive
                      ? Icons.check_circle_rounded
                      : Icons.history_rounded,
                  color: isActive ? AppColors.success : AppColors.textMuted,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isActive
                            ? 'Aktif İlaç (Güncel Tedavi)'
                            : 'Geçmiş İlaç (Tedavi Tamamlandı)',
                        style: TextStyle(
                          color: isActive
                              ? AppColors.success
                              : AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isActive
                            ? 'Bu ilaç hekiminiz tarafından aktif kullanım için reçete edilmiştir. Düzenli kullanmaya devam ediniz.'
                            : 'Bu ilacın tedavi süresi sona ermiştir. Güncel reçetenizde yer almamaktadır.',
                        style: TextStyle(
                          color: isActive
                              ? AppColors.success.withValues(alpha: 0.9)
                              : AppColors.textSecondary,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Detay Bölümleri Kartı
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                // 1. İlacı Yazan Hekim
                _buildDetailRow(
                  icon: Icons.person_pin_rounded,
                  label: 'İlacı Yazan Hekim',
                  value: medication.doctorName,
                  subtitle: medication.doctorBranch,
                ),
                const Divider(color: AppColors.border, height: 20),

                // 2. Yazılma Gerekçesi (Hastalık)
                _buildDetailRow(
                  icon: Icons.healing_rounded,
                  label: 'Yazılma Gerekçesi (Hastalık / Tanı)',
                  value: medication.diseaseReason,
                  valueColor: AppColors.secondary,
                ),
                const Divider(color: AppColors.border, height: 20),

                // 3. Son Kullanım Tarihi
                _buildDetailRow(
                  icon: Icons.hourglass_bottom_rounded,
                  label: 'Son Kullanım Tarihi',
                  value: medication.expiryDate,
                  valueColor: AppColors.warning,
                ),
                const Divider(color: AppColors.border, height: 20),

                // 4. Kullanım Talimatı (Aç/Tok, Dozaj Sıklığı)
                _buildDetailRow(
                  icon: Icons.schedule_rounded,
                  label: 'Kullanım Talimatı (Aç/Tok & Dozaj)',
                  value: medication.usageInstructions,
                  subtitle: medication.dosage,
                  valueColor: AppColors.primaryLight,
                ),
                const Divider(color: AppColors.border, height: 20),

                // 5. Reçete Durumu
                _buildDetailRow(
                  icon: Icons.info_outline_rounded,
                  label: 'Reçete ve Tedavi Durumu',
                  value: isActive
                      ? 'Aktif (Kullanılıyor)'
                      : 'Geçmiş (Kullanım Bitti)',
                  valueColor:
                      isActive ? AppColors.success : AppColors.textMuted,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Kullanım Detayı & Güvenlik Açıklaması
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline,
                    color: AppColors.primaryLight, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kullanım Önerisi',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        medication.instructionsDetail,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Barkod: ${medication.barcode}',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Hatırlatıcı Kur Butonu
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.alarm_add_rounded, size: 20),
              label: Text(
                isActive
                    ? 'Kullanım Hatırlatıcısı Kur'
                    : 'Geçmiş Reçeteyi Paylaş',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isActive ? AppColors.primary : AppColors.surfaceSecondary,
                foregroundColor:
                    isActive ? Colors.white : AppColors.textSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isActive
                          ? '${medication.name} için günlük dozaj hatırlatıcısı kuruldu.'
                          : '${medication.name} geçmiş reçete bilgisi kopyalandı.',
                    ),
                    backgroundColor:
                        isActive ? AppColors.success : AppColors.surface,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryLight),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
