import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Şifre alanı altındaki "Hesabınız yok mu? Kayıt Ol" ve "S.S.S." bağlantı alanı
class PatientAuthLinks extends StatelessWidget {
  final VoidCallback onRegisterTap;
  final VoidCallback onFaqTap;

  const PatientAuthLinks({
    super.key,
    required this.onRegisterTap,
    required this.onFaqTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // "Hesabınız yok mu? Kayıt Ol"
          Flexible(
            child: InkWell(
              key: const ValueKey('patient_register_link'),
              onTap: onRegisterTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(text: 'Hesabınız yok mu? '),
                      TextSpan(
                        text: 'Kayıt Ol',
                        style: TextStyle(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // "S.S.S." Bağlantısı
          InkWell(
            onTap: onFaqTap,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.help_outline_rounded,
                    size: 15,
                    color: AppColors.secondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'S.S.S.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
