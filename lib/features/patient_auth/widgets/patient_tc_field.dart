import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

/// Hasta T.C. Kimlik No giriş alanı
class PatientTcField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmitted;
  final bool isEnabled;

  const PatientTcField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onSubmitted,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'T.C. Kimlik Numarası',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final length = value.text.length;
                final isComplete = length == 11;
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: length > 0 ? 1.0 : 0.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isComplete
                          ? AppColors.success.withValues(alpha: 0.15)
                          : AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isComplete
                            ? AppColors.success.withValues(alpha: 0.5)
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      '$length / 11',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isComplete
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: isEnabled,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          maxLength: 11,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          onChanged: onChanged,
          onSubmitted: (_) => onSubmitted?.call(),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '11 haneli kimlik numaranız',
            prefixIcon: const Icon(
              Icons.badge_outlined,
              color: AppColors.primaryLight,
              size: 22,
            ),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  color: AppColors.textMuted,
                  tooltip: 'Temizle',
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
