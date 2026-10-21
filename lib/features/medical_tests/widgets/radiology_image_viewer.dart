import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Radyoloji Görseli Görüntüleyici (Zoom ve Tam Ekran Desteği)
class RadiologyImageViewer extends StatefulWidget {
  final String title;
  final bool isFullScreen;

  const RadiologyImageViewer({
    super.key,
    required this.title,
    this.isFullScreen = false,
  });

  @override
  State<RadiologyImageViewer> createState() => _RadiologyImageViewerState();
}

class _RadiologyImageViewerState extends State<RadiologyImageViewer> {
  final TransformationController _transformationController =
      TransformationController();

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _openFullScreenDialog() {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: RadiologyImageViewer(
                  title: widget.title,
                  isFullScreen: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF030712), // Koyu radyoloji negatif arka planı
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Zoom & Pan Desteği Sunan İnteraktif Radyoloji Görüntüsü
          InteractiveViewer(
            transformationController: _transformationController,
            minScale: 1.0,
            maxScale: 4.5,
            child: Center(
              child: CustomPaint(
                size: const Size(double.infinity, 240),
                painter: _RadiologyScanPainter(),
                child: Container(
                  height: widget.isFullScreen ? 500 : 220,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.monitor_heart_rounded,
                        size: widget.isFullScreen ? 72 : 48,
                        color: AppColors.primaryLight.withValues(alpha: 0.8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: widget.isFullScreen ? 15 : 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'DICOM #882419-XR  •  120 kVp / 3.2 mAs',
                        style: TextStyle(
                          color: AppColors.textMuted.withValues(alpha: 0.8),
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Sol Üst Anatomik Bilgi Katmanı
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pinch_rounded, color: AppColors.primaryLight, size: 12),
                  SizedBox(width: 4),
                  Text(
                    'Yakınlaştırmak için iki parmakla kaydırın',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),

          // Sağ Üst Kontrol Butonları (Reset & Tam Ekran)
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Yakınlaştırmayı Sıfırla',
                  icon: const Icon(Icons.restart_alt_rounded,
                      color: Colors.white70, size: 20),
                  onPressed: _resetZoom,
                ),
                if (!widget.isFullScreen)
                  IconButton(
                    tooltip: 'Tam Ekran Görüntüle',
                    icon: const Icon(Icons.fullscreen_rounded,
                        color: Colors.white, size: 22),
                    onPressed: _openFullScreenDialog,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dijital Röntgen & Tıbbi Tarama Arka Plan Çizicisi
class _RadiologyScanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = const Color(0xFF1E293B).withValues(alpha: 0.3)
      ..strokeWidth = 1;

    // Tıbbi ızgara çizgileri
    const step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paintGrid);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }

    // Anatomik merkezleme dairesi
    final centerPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height * 0.35,
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
