import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/hospital_cross_logo.dart';
import '../../patient_home/models/patient_model.dart';
import '../../patient_home/views/patient_home_view.dart';
import '../controllers/patient_register_controller.dart';
import '../models/patient_register_state.dart';

/// Hasta Kayıt Ekranı (Yeni Hasta Kayıt Formu)
class PatientRegisterView extends StatefulWidget {
  final String? initialTc;
  final PatientRegisterController? controller;

  const PatientRegisterView({
    super.key,
    this.initialTc,
    this.controller,
  });

  @override
  State<PatientRegisterView> createState() => _PatientRegisterViewState();
}

class _PatientRegisterViewState extends State<PatientRegisterView> {
  late final PatientRegisterController _controller;
  late final TextEditingController _tcController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _addressController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;

  final List<String> _bloodTypes = const [
    'A Rh(+)',
    'A Rh(-)',
    'B Rh(+)',
    'B Rh(-)',
    'AB Rh(+)',
    'AB Rh(-)',
    '0 Rh(+)',
    '0 Rh(-)',
  ];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PatientRegisterController();

    _tcController = TextEditingController(text: widget.initialTc ?? '');
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _birthDateController = TextEditingController();
    _addressController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();

    if (widget.initialTc != null && widget.initialTc!.isNotEmpty) {
      _controller.setTc(widget.initialTc!);
    }
  }

  @override
  void dispose() {
    _tcController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Tarih seçici modalını açar
  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initialDate = DateTime(1995, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'Doğum Tarihinizi Seçiniz',
      cancelText: 'Vazgeç',
      confirmText: 'Seç',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryLight,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted =
          '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
      _birthDateController.text = formatted;
      _controller.setBirthDate(formatted);
    }
  }

  /// KVKK ve Aydınlatma Metni Modalını gösterir
  void _showKvkkModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                controller: scrollController,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Icon(Icons.privacy_tip_rounded,
                          color: AppColors.secondary, size: 24),
                      SizedBox(width: 10),
                      Text(
                        'KVKK & Hasta Hakları Metni',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Acil Şifa Hastanesi olarak 6698 sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") ve ilgili mevzuat uyarınca, hastalarımızın kişisel ve sağlık verilerini en üst düzey güvenlik önlemleriyle korumaktayız.\n\n'
                    '1. Veri Sorumlusu:\nAcil Şifa Hastanesi Başhekimliği ve Sağlık Bilişim Departmanı.\n\n'
                    '2. İşleme Amacı:\nRandevu yönetimi, tıbbi teşhis, tedavi, bakım hizmetleri, tahlil/reçete takibi ve mevzuattan kaynaklanan yükümlülüklerin yerine getirilmesi.\n\n'
                    '3. Haklarınız:\nKVKK 11. maddesi kapsamında verilerinizin işlenip işlenmediğini öğrenme, yanlış işlenmişse düzeltilmesini isteme ve silinmesini talep etme hakkınız saklıdır.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _controller.setKvkkAccepted(true);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Okudum, Onaylıyorum'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Kayıt işlemini başlatır ve başarı durumunda modal/yönlendirme sunar
  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    final isSuccess = await _controller.register();
    if (!mounted) return;

    if (isSuccess && _controller.value.registeredPatient != null) {
      final patient = _controller.value.registeredPatient!;
      _showSuccessDialog(patient);
    }
  }

  /// Kayıt başarıyla tamamlandığında açılan onay penceresi
  void _showSuccessDialog(PatientModel patient) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.success, width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded,
                  color: AppColors.success, size: 28),
              SizedBox(width: 10),
              Text(
                'Kayıt Başarılı!',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 19,
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
                'Sayın ${patient.fullName}, Acil Şifa Hastanesi dijital hasta kartınız başarıyla oluşturuldu.',
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
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildDialogRow('T.C. Kimlik No:', patient.tc),
                    const Divider(color: AppColors.border, height: 14),
                    _buildDialogRow('Kan Grubu:', patient.bloodType),
                    const Divider(color: AppColors.border, height: 14),
                    _buildDialogRow('Cinsiyet:', patient.gender),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Doğrudan ana sayfaya gidebilir veya giriş sayfasına dönebilirsiniz.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop(patient);
              },
              child: const Text('Giriş Ekranına Dön'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (_) => PatientHomeView(initialPatient: patient),
                  ),
                );
              },
              child: const Text('Ana Sayfaya Git ➔'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Hasta Kaydı'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          tooltip: 'Giriş Ekranına Dön',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: ValueListenableBuilder<PatientRegisterState>(
                valueListenable: _controller,
                builder: (context, state, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hastane Logosu ve Başlık
                      const HospitalCrossLogo(
                        size: 64,
                        showTitle: true,
                        portalSubtitle: 'YENİ HASTA KAYIT FORMU',
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Acil Şifa Hastanesi dijital sağlık hizmetlerinden faydalanmak için lütfen aşağıdaki bilgileri eksiksiz doldurunuz.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),

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
                        const SizedBox(height: 16),
                      ],

                      // Form Kartı
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. KİŞİSEL & KİMLİK BİLGİLERİ
                            _buildSectionHeader(
                              icon: Icons.badge_outlined,
                              title: 'Kimlik Bilgileri',
                            ),
                            const SizedBox(height: 14),

                            // T.C. Kimlik Numarası
                            TextField(
                              controller: _tcController,
                              keyboardType: TextInputType.number,
                              maxLength: 11,
                              enabled: !state.isLoading,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                labelText: 'T.C. Kimlik Numarası *',
                                hintText: '11 Haneli T.C. Kimlik No',
                                prefixIcon: const Icon(Icons.badge_rounded,
                                    color: AppColors.primaryLight, size: 20),
                                counterText: '${state.tc.length}/11',
                                counterStyle: const TextStyle(
                                    color: AppColors.textMuted, fontSize: 11),
                              ),
                              onChanged: _controller.setTc,
                            ),
                            const SizedBox(height: 14),

                            // Ad Soyad
                            TextField(
                              controller: _fullNameController,
                              textCapitalization: TextCapitalization.words,
                              enabled: !state.isLoading,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                labelText: 'Ad ve Soyad *',
                                hintText: 'Örn: Ahmet Yılmaz',
                                prefixIcon: Icon(Icons.person_rounded,
                                    color: AppColors.primaryLight, size: 20),
                              ),
                              onChanged: _controller.setFullName,
                            ),
                            const SizedBox(height: 14),

                            // Doğum Tarihi & Cinsiyet Satırı
                            Row(
                              children: [
                                // Doğum Tarihi
                                Expanded(
                                  flex: 6,
                                  child: TextField(
                                    controller: _birthDateController,
                                    readOnly: true,
                                    onTap: state.isLoading ? null : _pickBirthDate,
                                    style: const TextStyle(
                                        color: AppColors.textPrimary),
                                    decoration: InputDecoration(
                                      labelText: 'Doğum Tarihi *',
                                      hintText: 'GG.AA.YYYY',
                                      prefixIcon: const Icon(
                                        Icons.calendar_today_rounded,
                                        color: AppColors.primaryLight,
                                        size: 18,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.event_rounded,
                                            size: 20),
                                        onPressed: state.isLoading
                                            ? null
                                            : _pickBirthDate,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Cinsiyet
                                Expanded(
                                  flex: 5,
                                  child: DropdownButtonFormField<String>(
                                    initialValue: state.gender,
                                    dropdownColor: AppColors.surface,
                                    decoration: const InputDecoration(
                                      labelText: 'Cinsiyet *',
                                      prefixIcon: Icon(Icons.wc_rounded,
                                          color: AppColors.primaryLight, size: 20),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Kadın',
                                        child: Text('Kadın'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Erkek',
                                        child: Text('Erkek'),
                                      ),
                                    ],
                                    onChanged: state.isLoading
                                        ? null
                                        : (val) {
                                            if (val != null) {
                                              _controller.setGender(val);
                                            }
                                          },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Kan Grubu Seçimi
                            DropdownButtonFormField<String>(
                              initialValue: state.bloodType,
                              dropdownColor: AppColors.surface,
                              decoration: const InputDecoration(
                                labelText: 'Kan Grubu *',
                                prefixIcon: Icon(Icons.bloodtype_rounded,
                                    color: AppColors.redCross, size: 20),
                              ),
                              items: _bloodTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: state.isLoading
                                  ? null
                                  : (val) {
                                      if (val != null) {
                                        _controller.setBloodType(val);
                                      }
                                    },
                            ),
                            const SizedBox(height: 22),

                            // 2. İLETİŞİM BİLGİLERİ
                            _buildSectionHeader(
                              icon: Icons.contact_phone_outlined,
                              title: 'İletişim Bilgileri',
                            ),
                            const SizedBox(height: 14),

                            // Telefon Numarası
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              enabled: !state.isLoading,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                labelText: 'Telefon Numarası *',
                                hintText: '05xx xxx xx xx',
                                prefixIcon: Icon(Icons.phone_iphone_rounded,
                                    color: AppColors.secondary, size: 20),
                              ),
                              onChanged: _controller.setPhone,
                            ),
                            const SizedBox(height: 14),

                            // E-posta Adresi
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              enabled: !state.isLoading,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                labelText: 'E-posta Adresi',
                                hintText: 'ornek@medauto.health',
                                prefixIcon: Icon(Icons.alternate_email_rounded,
                                    color: AppColors.secondary, size: 20),
                              ),
                              onChanged: _controller.setEmail,
                            ),
                            const SizedBox(height: 14),

                            // Adres / İkametgah
                            TextField(
                              controller: _addressController,
                              maxLines: 2,
                              enabled: !state.isLoading,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                labelText: 'İkametgah / Adres',
                                hintText: 'İl, ilçe ve açık adres bilgisi',
                                prefixIcon: Icon(Icons.location_on_outlined,
                                    color: AppColors.secondary, size: 20),
                              ),
                              onChanged: _controller.setAddress,
                            ),
                            const SizedBox(height: 22),

                            // 3. HESAP GÜVENLİĞİ (ŞİFRE)
                            _buildSectionHeader(
                              icon: Icons.lock_outline_rounded,
                              title: 'Hesap Güvenliği',
                            ),
                            const SizedBox(height: 14),

                            // Şifre
                            TextField(
                              controller: _passwordController,
                              obscureText: !state.isPasswordVisible,
                              enabled: !state.isLoading,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                labelText: 'Şifre Belirleyiniz (En az 6 karakter) *',
                                prefixIcon: const Icon(Icons.lock_rounded,
                                    color: AppColors.primaryLight, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isPasswordVisible
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: AppColors.textMuted,
                                    size: 20,
                                  ),
                                  onPressed:
                                      _controller.togglePasswordVisibility,
                                ),
                              ),
                              onChanged: _controller.setPassword,
                            ),
                            const SizedBox(height: 14),

                            // Şifre Tekrarı
                            TextField(
                              controller: _passwordConfirmController,
                              obscureText: !state.isPasswordConfirmVisible,
                              enabled: !state.isLoading,
                              style: const TextStyle(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                labelText: 'Şifre Tekrarı *',
                                prefixIcon: const Icon(Icons.lock_reset_rounded,
                                    color: AppColors.primaryLight, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isPasswordConfirmVisible
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: AppColors.textMuted,
                                    size: 20,
                                  ),
                                  onPressed:
                                      _controller.togglePasswordConfirmVisibility,
                                ),
                              ),
                              onChanged: _controller.setPasswordConfirm,
                            ),
                            const SizedBox(height: 20),

                            // 4. KVKK VE ŞARTLAR ONAYI
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: state.isKvkkAccepted,
                                    activeColor: AppColors.primary,
                                    onChanged: state.isLoading
                                        ? null
                                        : (val) {
                                            _controller
                                                .setKvkkAccepted(val ?? false);
                                          },
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _showKvkkModal,
                                      child: RichText(
                                        text: const TextSpan(
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'KVKK ve Hasta Hakları ',
                                              style: TextStyle(
                                                color: AppColors.primaryLight,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  'Aydınlatma Metni\'ni okudum ve onaylıyorum.',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.info_outline_rounded,
                                        size: 18,
                                        color: AppColors.secondary),
                                    tooltip: 'Metni Görüntüle',
                                    onPressed: _showKvkkModal,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // 5. KAYIT OL BUTONU
                            Container(
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: AppColors.buttonGradient,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.35),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed:
                                    state.isLoading ? null : _handleRegister,
                                child: state.isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.how_to_reg_rounded,
                                              size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            'Hasta Kaydını Tamamla',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Giriş Yap Bağlantısı
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                    children: [
                                      TextSpan(text: 'Zaten hesabınız var mı? '),
                                      TextSpan(
                                        text: 'Giriş Yap',
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
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

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryLight, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Divider(color: AppColors.border, thickness: 1),
        ),
      ],
    );
  }
}
