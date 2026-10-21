import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Acil Şifa Hastanesi Kızıl Haç Amblemi ve Başlık Bileşeni
class HospitalCrossLogo extends StatelessWidget {
  final double size;
  final bool showTitle;
  final String? portalSubtitle;

  const HospitalCrossLogo({
    super.key,
    this.size = 76,
    this.showTitle = true,
    this.portalSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTitle) ...[
          // Hastane İsmi
          const Text(
            'ACİL ŞİFA HASTANESİ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '7/24 Kesintisiz Sağlık & Güvenilir Hizmet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Kızıl Haç Görseli / Amblemi
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.redCross.withValues(alpha: 0.45),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
            border: Border.all(
              color: AppColors.redCross.withValues(alpha: 0.3),
              width: 2.5,
            ),
          ),
          child: Center(
            child: CustomPaint(
              size: Size(size * 0.58, size * 0.58),
              painter: _RedCrossPainter(),
            ),
          ),
        ),

        if (portalSubtitle != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  portalSubtitle!,
                  style: const TextStyle(
                    color: AppColors.primaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Kızıl Haç (Red Cross) Simgesi Çizicisi
class _RedCrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.redCross
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final barThickness = w * 0.34;
    final cornerRadius = Radius.circular(barThickness * 0.15);

    // Dikey Kol
    final verticalRect = RRect.fromRectAndRadius(
      Rect.fromLTWH((w - barThickness) / 2, 0, barThickness, h),
      cornerRadius,
    );
    canvas.drawRRect(verticalRect, paint);

    // Yatay Kol
    final horizontalRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, (h - barThickness) / 2, w, barThickness),
      cornerRadius,
    );
    canvas.drawRRect(horizontalRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
