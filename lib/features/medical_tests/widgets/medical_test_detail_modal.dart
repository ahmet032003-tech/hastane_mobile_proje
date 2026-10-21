import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/medical_test_model.dart';
import 'lab_results_table.dart';
import 'radiology_image_viewer.dart';

/// Radyoloji ve Tahlil Detay Ekranı / Modalı (SKILL.md 1.6)
/// İstemde bulunan hekim, istem gerekçesi/amacı, test görseli veya lab tablosu, uzman klinik yorumu
class MedicalTestDetailModal extends StatelessWidget {
  final MedicalTestModel test;

  const MedicalTestDetailModal({
    super.key,
    required this.test,
  });

  @override
  Widget build(BuildContext context) {
    final isRadiology = test.isRadiology;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),

              // Başlık ve Kapatma Butonu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isRadiology
                                      ? AppColors.primary.withValues(alpha: 0.15)
                                      : AppColors.accentTeal
                                          .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  test.categoryName,
                                  style: TextStyle(
                                    color: isRadiology
                                        ? AppColors.primaryLight
                                        : AppColors.accentTeal,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.success
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  test.status,
                                  style: const TextStyle(
                                    color: AppColors.success,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            test.testName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 22),
                      color: AppColors.textMuted,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(color: AppColors.border, height: 1),

              // Kaydırılabilir İçerik
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    // 1. İstemde Bulunan Hekim Kartı
                    _buildSectionCard(
                      icon: Icons.person_pin_rounded,
                      title: 'İstemde Bulunan Hekim',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            test.requestingDoctor,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            test.requestingDoctorBranch,
                            style: const TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  size: 13, color: AppColors.textMuted),
                              const SizedBox(width: 6),
                              Text(
                                'İstem Tarihi: ${test.formattedDate}',
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. İstem Gerekçesi / Amacı
                    _buildSectionCard(
                      icon: Icons.help_outline_rounded,
                      title: 'İstem Gerekçesi ve Amacı',
                      child: Text(
                        test.requestReason,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Test Sonucu: Radyoloji Görseli (Zoom/Tam Ekran) VEYA Lab Değer Tablosu
                    Row(
                      children: [
                        Icon(
                          isRadiology
                              ? Icons.camera_alt_outlined
                              : Icons.table_chart_outlined,
                          size: 18,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isRadiology
                              ? 'Radyoloji Görüntüsü'
                              : 'Laboratuvar Değer Tablosu',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (isRadiology)
                      RadiologyImageViewer(
                        title: test.radiologyImageTitle ??
                            'Dijital Radyoloji Görüntüsü',
                      )
                    else if (test.labResults != null)
                      LabResultsTable(results: test.labResults!),

                    const SizedBox(height: 20),

                    // 4. Uzman / Hekim Açık Klinik Rapor Yorumu
                    _buildSectionCard(
                      icon: Icons.rate_review_outlined,
                      title: 'Uzman Hekim Açık Klinik Yorumu',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.border,
                              ),
                            ),
                            child: Text(
                              test.doctorClinicalComment,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                height: 1.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.verified_rounded,
                                      size: 14, color: AppColors.success),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Elektronik İmzalı Resmi Rapor',
                                    style: TextStyle(
                                      color: AppColors.success
                                          .withValues(alpha: 0.9),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                test.requestingDoctor,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Rapor İndirme Butonu
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                        label: const Text('Raporu PDF Olarak İndir'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Klinik rapor PDF olarak cihazınıza indirildi.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
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
            children: [
              Icon(icon, color: AppColors.primaryLight, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
