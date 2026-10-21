import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/hospital_cross_logo.dart';
import '../../doctor_dashboard/views/doctor_dashboard_view.dart';
import '../../patient_auth/views/patient_login_view.dart';
import '../controllers/doctor_login_controller.dart';
import '../models/doctor_login_state.dart';

/// Doktor Giriş Ekranı (features/doctor_auth)
/// Alanlar: T.C. / Diploma Tescil No, Kurum Kodu, Şifre
/// Bağlantılar: "Şifremi Unuttum" ve "Kurumsal Bilgi İşlem / S.S.S."
class DoctorLoginView extends StatefulWidget {
  final DoctorLoginController? controller;

  const DoctorLoginView({
    super.key,
    this.controller,
  });

  @override
  State<DoctorLoginView> createState() => _DoctorLoginViewState();
}

class _DoctorLoginViewState extends State<DoctorLoginView> {
  late final DoctorLoginController _controller;
  late final TextEditingController _diplomaController;
  late final TextEditingController _institutionController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DoctorLoginController();
    _diplomaController = TextEditingController();
    _institutionController = TextEditingController(text: 'ASH-34');
    _passwordController = TextEditingController();

    _controller.setInstitutionCode('ASH-34');
  }

  @override
  void dispose() {
    _diplomaController.dispose();
    _institutionController.dispose();
    _passwordController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final isSuccess = await _controller.login();
    if (!mounted) return;

    if (isSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const DoctorDashboardView(),
        ),
      );
    }
  }

  void _showForgotPasswordDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Text('Şifre Sıfırlama',
              style: TextStyle(color: AppColors.textPrimary)),
          content: const Text(
            'Kurumsal hekim şifrenizi yenilemek için kayıtlı kurumsal e-postanıza veya hastane Bilgi İşlem birimine başvurabilirsiniz.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  void _showITSupportModal() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.headset_mic_rounded,
                      color: AppColors.primaryLight, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Kurumsal Bilgi İşlem / S.S.S.',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Acil Şifa Hastanesi Bilgi İşlem Daire Başkanlığı:',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Dahili Telefon: 4444 (7/24 Kesintisiz Destek)\n• E-İmza & Token Desteği: bim@acilsifa.gov.tr\n• Kurum Kodu: ASH-34 (İstanbul Bölge)',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 12, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Kapat'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: ValueListenableBuilder<DoctorLoginState>(
                valueListenable: _controller,
                builder: (context, state, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Acil Şifa Hastanesi İsmi ve Kızıl Haç Amblemi
                      const HospitalCrossLogo(
                        size: 78,
                        showTitle: true,
                        portalSubtitle: 'HEKİM & DOKTOR PORTALI',
                      ),
                      const SizedBox(height: 24),

                      // Hata Mesajı
                      if (state.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.errorBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.error),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: AppColors.error, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  state.errorMessage!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],

                      // Doktor Giriş Kartı Formu
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. T.C. / Diploma Tescil No
                            const Text(
                              'T.C. / Diploma Tescil No',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _diplomaController,
                              enabled: !state.isLoading,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onChanged: _controller.setDiplomaOrTc,
                              style: const TextStyle(
                                  color: AppColors.textPrimary, fontSize: 15),
                              decoration: const InputDecoration(
                                hintText: 'Tescil numaranızı giriniz',
                                prefixIcon: Icon(Icons.badge_outlined,
                                    color: AppColors.primaryLight, size: 20),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 2. Kurum Kodu
                            const Text(
                              'Kurum Kodu',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _institutionController,
                              enabled: !state.isLoading,
                              textInputAction: TextInputAction.next,
                              onChanged: _controller.setInstitutionCode,
                              style: const TextStyle(
                                  color: AppColors.textPrimary, fontSize: 15),
                              decoration: const InputDecoration(
                                hintText: 'Örn: ASH-34',
                                prefixIcon: Icon(Icons.corporate_fare_rounded,
                                    color: AppColors.secondary, size: 20),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 3. Şifre
                            const Text(
                              'Hekim Şifresi',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _passwordController,
                              enabled: !state.isLoading,
                              obscureText: !state.isPasswordVisible,
                              textInputAction: TextInputAction.done,
                              onChanged: _controller.setPassword,
                              onSubmitted: (_) => _handleLogin(),
                              style: const TextStyle(
                                  color: AppColors.textPrimary, fontSize: 15),
                              decoration: InputDecoration(
                                hintText: 'Şifrenizi giriniz',
                                prefixIcon: const Icon(Icons.lock_outline_rounded,
                                    color: AppColors.primaryLight, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isPasswordVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textMuted,
                                    size: 20,
                                  ),
                                  onPressed:
                                      _controller.togglePasswordVisibility,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Bağlantılar: "Şifremi Unuttum" ve "Kurumsal Bilgi İşlem / S.S.S."
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 8,
                              children: [
                                InkWell(
                                  onTap: _showForgotPasswordDialog,
                                  child: const Text(
                                    'Şifremi Unuttum',
                                    style: TextStyle(
                                      color: AppColors.primaryLight,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: _showITSupportModal,
                                  child: const Text(
                                    'Kurumsal Bilgi İşlem / S.S.S.',
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Giriş Yap Butonu
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed:
                                    state.isLoading ? null : _handleLogin,
                                child: state.isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.login_rounded,
                                              size: 20, color: Colors.white),
                                          SizedBox(width: 8),
                                          Text(
                                            'Doktor Girişi Yap',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Test Hesabı Butonu
                      Center(
                        child: TextButton.icon(
                          icon: const Icon(Icons.flash_on_rounded,
                              size: 16, color: AppColors.warning),
                          label: const Text(
                            'Demo Hekim Hesabını Doldur (123456 / ASH-34 / 123456)',
                            style: TextStyle(
                              color: AppColors.warning,
                              fontSize: 11,
                            ),
                          ),
                          onPressed: () {
                            _diplomaController.text = '123456';
                            _institutionController.text = 'ASH-34';
                            _passwordController.text = '123456';
                            _controller.setDiplomaOrTc('123456');
                            _controller.setInstitutionCode('ASH-34');
                            _controller.setPassword('123456');
                          },
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Hasta Portalı Girişine Geçiş Butonu
                      Center(
                        child: TextButton.icon(
                          icon: const Icon(Icons.person_outline_rounded,
                              size: 18, color: AppColors.primaryLight),
                          label: const Text(
                            'Hasta Portalı Girişi İçin Tıklayınız ➔',
                            style: TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => const PatientLoginView(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
