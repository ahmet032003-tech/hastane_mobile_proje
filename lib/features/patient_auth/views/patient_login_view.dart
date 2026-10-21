import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/patient_login_controller.dart';
import '../models/patient_login_state.dart';
import '../widgets/patient_auth_header.dart';
import '../widgets/patient_auth_links.dart';
import '../widgets/patient_login_button.dart';
import '../widgets/patient_password_field.dart';
import '../widgets/patient_tc_field.dart';
import '../../doctor_auth/views/doctor_login_view.dart';
import '../../patient_home/models/patient_model.dart';
import '../../patient_home/views/patient_home_view.dart';
import 'patient_register_view.dart';

/// Hasta Giriş Ekranı (ValueListenableBuilder ile reaktif olarak dinlenir)
class PatientLoginView extends StatefulWidget {
  final PatientLoginController? controller;

  const PatientLoginView({
    super.key,
    this.controller,
  });

  @override
  State<PatientLoginView> createState() => _PatientLoginViewState();
}

class _PatientLoginViewState extends State<PatientLoginView> {
  late final PatientLoginController _controller;
  late final TextEditingController _tcTextController;
  late final TextEditingController _passwordTextController;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PatientLoginController();
    _tcTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _tcTextController.dispose();
    _passwordTextController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Giriş işlemini tetikler ve sonuca göre yönlendirmeleri ele alır
  Future<void> _handleLogin() async {
    // Klavyeyi kapat
    FocusScope.of(context).unfocus();

    final isSuccess = await _controller.login();
    if (!mounted) return;

    final currentState = _controller.value;

    if (isSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => PatientHomeView(
            initialPatient: _controller.authenticatedPatient,
          ),
        ),
      );
    } else if (currentState.shouldRedirectToRegister) {
      _showRegistrationRedirectDialog(currentState.errorMessage);
    }
  }

  /// Geçersiz veya kayıtsız girişte kullanıcıya gösterilen yönlendirme modalı
  void _showRegistrationRedirectDialog(String? message) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Row(
            children: [
              Icon(Icons.person_add_alt_1_rounded,
                  color: AppColors.primaryLight, size: 26),
              SizedBox(width: 10),
              Text(
                'Kayıt Bulunamadı',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message ??
                    'Girdiğiniz T.C. Kimlik Numarası sistemde kayıtlı değildir.',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColors.primaryLight, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Hastanemizden randevu alabilmek için birkaç adımda hızlıca kayıt olabilirsiniz.',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Tekrar Dene'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(130, 44),
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _navigateToRegister(_controller.value.tc);
              },
              child: const Text('Kayıt Ekranına Git'),
            ),
          ],
        );
      },
    );
  }

  /// Kayıt ol sayfasına yönlendirme (PatientRegisterView)
  Future<void> _navigateToRegister([String? initialTc]) async {
    final effectiveTc = initialTc ??
        (_controller.value.tc.length == 11 ? _controller.value.tc : null);

    final registeredPatient = await Navigator.of(context).push<PatientModel>(
      MaterialPageRoute<PatientModel>(
        builder: (_) => PatientRegisterView(initialTc: effectiveTc),
      ),
    );

    if (!mounted || registeredPatient == null) return;

    // Kayıt tamamlandıktan sonra giriş ekranına dönüldüyse T.C. bilgisini otomatik doldur
    _tcTextController.text = registeredPatient.tc;
    _controller.setTc(registeredPatient.tc);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sayın ${registeredPatient.fullName}, kaydınız tamamlandı. Şifrenizi girerek giriş yapabilirsiniz.',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// S.S.S. (Sıkça Sorulan Sorular) modalı
  void _showFaqModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                controller: scrollController,
                children: [
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(Icons.quiz_outlined,
                          color: AppColors.secondary, size: 24),
                      SizedBox(width: 10),
                      Text(
                        'Sıkça Sorulan Sorular',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFaqItem(
                    question: 'Hasta hesabıma nasıl giriş yapabilirim?',
                    answer:
                        '11 haneli T.C. Kimlik numaranız ve daha önce oluşturduğunuz şifrenizle giriş yapabilirsiniz.',
                  ),
                  _buildFaqItem(
                    question: 'Şifremi unuttum, ne yapmalıyım?',
                    answer:
                        'Hastanemiz bilgi işlem birimine başvurarak veya SMS doğrulama adımıyla şifrenizi yenileyebilirsiniz.',
                  ),
                  _buildFaqItem(
                    question: 'İlk defa randevu alacağım, ne yapmalıyım?',
                    answer:
                        '"Kayıt Ol" bağlantısına tıklayarak kimlik ve iletişim bilgilerinizi girip saniyeler içinde kayıt olabilirsiniz.',
                  ),
                  _buildFaqItem(
                    question: 'Tahlil ve reçetelerimi nereden görebilirim?',
                    answer:
                        'Giriş yaptıktan sonra hasta ana panelinde yer alan "İlaçlar/Reçeteler" ve "Radyoloji/Tahliller" sekmelerinden ulaşabilirsiniz.',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: AppColors.primaryLight,
        collapsedIconColor: AppColors.textMuted,
        title: Text(
          question,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
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
              child: ValueListenableBuilder<PatientLoginState>(
                valueListenable: _controller,
                builder: (context, state, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Başlık ve MedAuto Logo
                      const PatientAuthHeader(),
                      const SizedBox(height: 28),

                      // Hata Mesajı Bildirimi (Varsa)
                      if (state.errorMessage != null && state.isFailure) ...[
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.errorBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.6),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: AppColors.error,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  state.errorMessage!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],

                      // Giriş Kartı Formu
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
                            // 1. T.C. Kimlik No Giriş Alanı
                            PatientTcField(
                              controller: _tcTextController,
                              isEnabled: !state.isLoading,
                              onChanged: _controller.setTc,
                              onSubmitted: () => FocusScope.of(context).nextFocus(),
                            ),
                            const SizedBox(height: 18),

                            // 2. Şifre Giriş Alanı
                            PatientPasswordField(
                              controller: _passwordTextController,
                              isPasswordVisible: state.isPasswordVisible,
                              isEnabled: !state.isLoading,
                              onChanged: _controller.setPassword,
                              onToggleVisibility: _controller.togglePasswordVisibility,
                              onSubmitted: _handleLogin,
                            ),
                            const SizedBox(height: 12),

                            // 3. Şifre Altı Bölümü: "Hesabınız yok mu? Kayıt Ol" ve "S.S.S."
                            PatientAuthLinks(
                              onRegisterTap: _navigateToRegister,
                              onFaqTap: _showFaqModal,
                            ),
                            const SizedBox(height: 24),

                            // 4. Giriş Yap Butonu
                            PatientLoginButton(
                              isLoading: state.isLoading,
                              onPressed: _handleLogin,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Demo / Hızlı Test Bilgi Kartı
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSecondary.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lightbulb_outline_rounded,
                                  size: 14,
                                  color: AppColors.warning,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Test Kullanıcı Bilgisi',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 12,
                              runSpacing: 4,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _tcTextController.text = '12345678901';
                                    _passwordTextController.text = '123456';
                                    _controller.setTc('12345678901');
                                    _controller.setPassword('123456');
                                  },
                                  child: const Text(
                                    'Kayıtlı: 12345678901 / 123456',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.primaryLight,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _tcTextController.text = '99999999999';
                                    _passwordTextController.text = '123456';
                                    _controller.setTc('99999999999');
                                    _controller.setPassword('123456');
                                  },
                                  child: const Text(
                                    'Kayıtsız: 99999999999 (Yönlendirme Testi)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Doktor / Hekim Giriş Portalı Yönlendirmesi
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton.icon(
                          icon: const Icon(
                            Icons.medical_services_rounded,
                            size: 18,
                            color: AppColors.secondary,
                          ),
                          label: const Text(
                            '👨‍⚕️ Hekim & Doktor Giriş Portalı ➔',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const DoctorLoginView(),
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
