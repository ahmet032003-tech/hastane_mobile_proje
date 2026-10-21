import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../patient_auth/services/patient_auth_repository.dart';
import '../../patient_auth/views/patient_login_view.dart';
import '../../patient_home/models/patient_model.dart';

/// Hasta Profil Sayfası (features/patient_profile)
/// Büyük hasta profil resmi, ad-soyad, T.C. kimlik no ve kişisel bilgi satırları
class PatientProfileView extends StatelessWidget {
  final PatientModel patient;
  final ValueChanged<PatientModel>? onPatientUpdated;

  const PatientProfileView({
    super.key,
    required this.patient,
    this.onPatientUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasta Profili'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.error),
            tooltip: 'Çıkış Yap',
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // 1. Üst Bölüm: Büyük Hasta Profil Resmi, Ad-Soyad, T.C. No
            _buildProfileHeader(context),
            const SizedBox(height: 24),

            // 2. Kişisel Bilgiler Listesi
            _buildPersonalInfoSection(context),
            const SizedBox(height: 20),

            // 3. Sağlık & Hesap Güvenliği Butonları
            _buildSecuritySection(context),
            const SizedBox(height: 24),

            // 4. Çıkış Yap Butonu
            _buildLogoutButton(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Büyük hasta profil resmi, ad-soyad ve T.C. Kimlik alanı
  Widget _buildProfileHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: CircleAvatar(
                    backgroundColor: AppColors.surface,
                    child: const Text(
                      'AY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ad - Soyad
          Text(
            patient.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),

          // T.C. Kimlik No Etiketi
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: patient.tc));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('T.C. Kimlik Numarası panoya kopyalandı.'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    size: 16,
                    color: AppColors.primaryLight,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'T.C. ${patient.tc}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.copy_rounded,
                    size: 13,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Kişisel Bilgiler Listesi Satırları
  /// Doğum tarihi, cinsiyet, kan grubu, telefon, e-posta, ikametgah
  Widget _buildPersonalInfoSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.person_pin_rounded,
                  color: AppColors.primaryLight,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Kişisel Bilgiler',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          _buildInfoTile(
            icon: Icons.cake_outlined,
            label: 'Doğum Tarihi',
            value: patient.birthDate,
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.transgender_rounded,
            label: 'Cinsiyet',
            value: patient.gender,
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.bloodtype_outlined,
            label: 'Kan Grubu',
            value: patient.bloodType,
            valueColor: AppColors.error,
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            label: 'Telefon Numarası',
            value: patient.phone,
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.mail_outline_rounded,
            label: 'E-Posta Adresi',
            value: patient.email,
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.home_outlined,
            label: 'İkametgah Adresi',
            value: patient.address,
            isMultiLine: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isMultiLine = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment:
            isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.secondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 56),
      child: Divider(color: AppColors.border, height: 1),
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            key: const ValueKey('change_password_tile'),
            leading: const Icon(Icons.lock_reset_rounded,
                color: AppColors.primaryLight),
            title: const Text(
              'Şifre Değiştir',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textMuted),
            onTap: () => _showChangePasswordModal(context),
          ),
          const Divider(color: AppColors.border, height: 1),
          ListTile(
            leading:
                const Icon(Icons.privacy_tip_outlined, color: AppColors.secondary),
            title: const Text(
              'KVKK ve Sağlık Verisi İzinleri',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textMuted),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tüm hasta verileriniz Sağlık Bakanlığı standartlarında korunmaktadır.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
        label: const Text(
          'Oturumu Kapat',
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () => _handleLogout(context),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          title: const Text(
            'Çıkış Yapılsın mı?',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: const Text(
            'MedAuto hasta portalından çıkmak istediğinize emin misiniz?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Vazgeç'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) => const PatientLoginView(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Çıkış Yap'),
            ),
          ],
        );
      },
    );
  }

  /// Şifre Değiştirme Modalını Gösterir (Mevcut Şifre Doğrulaması İle)
  void _showChangePasswordModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return _ChangePasswordSheet(
          patientTc: patient.tc,
          patientName: patient.fullName,
        );
      },
    );
  }
}

/// Mevcut şifre ve yeni şifre belirleme formu
class _ChangePasswordSheet extends StatefulWidget {
  final String patientTc;
  final String patientName;

  const _ChangePasswordSheet({
    required this.patientTc,
    required this.patientName,
  });

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _newPasswordConfirmController;

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isNewPasswordConfirmVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _newPasswordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _handlePasswordChange() async {
    FocusScope.of(context).unfocus();

    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final newPasswordConfirm = _newPasswordConfirmController.text.trim();

    if (oldPassword.isEmpty) {
      setState(() => _errorMessage = 'Lütfen mevcut şifrenizi giriniz.');
      return;
    }

    // 1. Mevcut şifre doğrulaması
    final isOldValid = PatientAuthRepository.instance
        .verifyPassword(widget.patientTc, oldPassword);

    if (!isOldValid) {
      setState(() => _errorMessage =
          'Mevcut şifreniz hatalı. Lütfen kontrol edip tekrar deneyiniz.');
      return;
    }

    // 2. Yeni şifre kontrolleri
    if (newPassword.isEmpty) {
      setState(() => _errorMessage = 'Lütfen yeni şifrenizi giriniz.');
      return;
    }

    if (newPassword.length < 6) {
      setState(
          () => _errorMessage = 'Yeni şifreniz en az 6 karakter olmalıdır.');
      return;
    }

    if (newPassword == oldPassword) {
      setState(() => _errorMessage =
          'Yeni şifreniz mevcut şifreniz ile aynı olamaz. Lütfen farklı bir şifre seçiniz.');
      return;
    }

    if (newPassword != newPasswordConfirm) {
      setState(() => _errorMessage = 'Yeni şifreler birbiriyle eşleşmiyor.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 400));

    final isSuccess = PatientAuthRepository.instance.updatePassword(
      widget.patientTc,
      oldPassword,
      newPassword,
    );

    if (!mounted) return;

    if (isSuccess) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sayın ${widget.patientName}, şifreniz başarıyla değiştirildi! Yeni şifreniz aktif edilmiştir.',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Şifre güncellenemedi. Lütfen tekrar deneyiniz.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sürükleme Tutamacı
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Başlık
            const Row(
              children: [
                Icon(
                  Icons.lock_reset_rounded,
                  color: AppColors.primaryLight,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'Şifre Değiştir',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Hesap güvenliğiniz için lütfen önce mevcut şifrenizi doğrulayınız, ardından en az 6 karakterli yeni şifrenizi tanımlayınız.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Hata Bildirimi (Varsa)
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.error),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // 1. Mevcut Şifre Alanı
            TextField(
              controller: _oldPasswordController,
              obscureText: !_isOldPasswordVisible,
              enabled: !_isLoading,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Mevcut Şifre *',
                hintText: 'Şu anki şifrenizi giriniz',
                prefixIcon: const Icon(Icons.lock_outline_rounded,
                    color: AppColors.secondary, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isOldPasswordVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isOldPasswordVisible = !_isOldPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 2. Yeni Şifre Alanı
            TextField(
              controller: _newPasswordController,
              obscureText: !_isNewPasswordVisible,
              enabled: !_isLoading,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Yeni Şifre *',
                hintText: 'En az 6 karakter',
                prefixIcon: const Icon(Icons.password_rounded,
                    color: AppColors.primaryLight, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 3. Yeni Şifre Tekrarı Alanı
            TextField(
              controller: _newPasswordConfirmController,
              obscureText: !_isNewPasswordConfirmVisible,
              enabled: !_isLoading,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Yeni Şifre Tekrarı *',
                hintText: 'Yeni şifrenizi tekrar giriniz',
                prefixIcon: const Icon(Icons.check_circle_outline_rounded,
                    color: AppColors.primaryLight, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordConfirmVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordConfirmVisible =
                          !_isNewPasswordConfirmVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 22),

            // 4. Şifre Değiştir ve Vazgeç Butonları
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Vazgeç'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      key: const ValueKey('submit_change_password_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: _isLoading ? null : _handlePasswordChange,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Şifreyi Güncelle',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

