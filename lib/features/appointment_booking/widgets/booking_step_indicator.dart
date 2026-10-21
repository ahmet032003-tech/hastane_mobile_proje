import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// 4 Adımlı Sıralı Seçim Sihirbazı İlerleme Çubuğu
class BookingStepIndicator extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int>? onStepTapped;

  const BookingStepIndicator({
    super.key,
    required this.currentStep,
    this.onStepTapped,
  });

  static const List<String> _stepTitles = [
    'Hastane',
    'Bölüm',
    'Doktor',
    'Tarih/Saat',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: List.generate(_stepTitles.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Adımlar arası bağlantı çizgisi
            final stepIndex = index ~/ 2;
            final isPassed = currentStep > stepIndex;

            return Expanded(
              child: Container(
                height: 2,
                color: isPassed ? AppColors.primaryLight : AppColors.border,
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final isCompleted = currentStep > stepIndex;
          final isCurrent = currentStep == stepIndex;

          return InkWell(
            onTap: onStepTapped != null ? () => onStepTapped!(stepIndex) : null,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.primary
                          : (isCurrent
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : AppColors.surfaceSecondary),
                      border: Border.all(
                        color: isCurrent || isCompleted
                            ? AppColors.primaryLight
                            : AppColors.border,
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : Text(
                              '${stepIndex + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isCurrent
                                    ? AppColors.primaryLight
                                    : AppColors.textMuted,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _stepTitles[stepIndex],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                      color: isCurrent
                          ? AppColors.textPrimary
                          : (isCompleted
                              ? AppColors.primaryLight
                              : AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
