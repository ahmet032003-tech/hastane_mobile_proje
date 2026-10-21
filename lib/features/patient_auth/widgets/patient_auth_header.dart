import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/hospital_cross_logo.dart';

/// Hasta giriş ekranı marka başlığı ve Acil Şifa Hastanesi Kızıl Haç amblemi
class PatientAuthHeader extends StatelessWidget {
  const PatientAuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Hastane İsmi ve Kızıl Haç Amblemi
        HospitalCrossLogo(
          size: 78,
          showTitle: true,
          portalSubtitle: 'HASTA GİRİŞ PORTALI',
        ),
        SizedBox(height: 16),

        // Açıklama
        Text(
          'Randevu alma, tahlil sonuçları ve reçete takibi için T.C. Kimlik numaranızla giriş yapın.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
