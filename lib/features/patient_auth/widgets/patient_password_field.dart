import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Hasta şifre giriş alanı (gizle/göster ikonu ile)
class PatientPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPasswordVisible;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleVisibility;
  final VoidCallback? onSubmitted;
  final bool isEnabled;

  const PatientPasswordField({
    super.key,
    required this.controller,
    required this.isPasswordVisible,
    required this.onChanged,
    required this.onToggleVisibility,
    this.onSubmitted,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Şifre',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: isEnabled,
          obscureText: !isPasswordVisible,
          textInputAction: TextInputAction.done,
          onChanged: onChanged,
          onSubmitted: (_) => onSubmitted?.call(),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Şifrenizi giriniz',
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.primaryLight,
              size: 22,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: isPasswordVisible
                    ? AppColors.primaryLight
                    : AppColors.textMuted,
                size: 22,
              ),
              tooltip: isPasswordVisible ? 'Şifreyi gizle' : 'Şifreyi göster',
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
