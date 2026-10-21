import 'package:flutter/foundation.dart';
import '../models/patient_login_state.dart';
import '../../patient_home/models/patient_model.dart';
import '../services/patient_auth_repository.dart';

/// Hasta giriş iş mantığını ve durumunu yöneten ValueNotifier controller
class PatientLoginController extends ValueNotifier<PatientLoginState> {
  final PatientAuthRepository _authRepository;
  PatientModel? _authenticatedPatient;

  PatientModel? get authenticatedPatient => _authenticatedPatient;

  PatientLoginController({
    PatientLoginState? initialState,
    PatientAuthRepository? authRepository,
  })  : _authRepository = authRepository ?? PatientAuthRepository.instance,
        super(initialState ?? const PatientLoginState());

  /// T.C. Kimlik Numarasını günceller
  void setTc(String tc) {
    // Yalnızca rakamları kabul et ve maksimum 11 hane ile sınırla
    final sanitized = tc.replaceAll(RegExp(r'[^0-9]'), '');
    final limited = sanitized.length > 11 ? sanitized.substring(0, 11) : sanitized;

    value = value.copyWith(
      tc: limited,
      clearErrorMessage: true,
      shouldRedirectToRegister: false,
      status: PatientLoginStatus.initial,
    );
  }

  /// Şifreyi günceller
  void setPassword(String password) {
    value = value.copyWith(
      password: password,
      clearErrorMessage: true,
      shouldRedirectToRegister: false,
      status: PatientLoginStatus.initial,
    );
  }

  /// Şifre görünürlüğünü açar / kapatır
  void togglePasswordVisibility() {
    value = value.copyWith(
      isPasswordVisible: !value.isPasswordVisible,
    );
  }

  /// Hata veya yönlendirme bayrağını sıfırlar
  void resetRedirectionFlag() {
    value = value.copyWith(
      shouldRedirectToRegister: false,
    );
  }

  /// T.C. Kimlik No biçimsel doğrulama
  bool _isValidTc(String tc) {
    if (tc.length != 11) return false;
    if (!RegExp(r'^[1-9][0-9]{10}$').hasMatch(tc)) return false;

    // Standart T.C. algoritma kontrolü (opsiyonel demo toleransı ile)
    final digits = tc.split('').map(int.parse).toList();
    final sumOdd = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
    final sumEven = digits[1] + digits[3] + digits[5] + digits[7];
    final tenthDigit = ((sumOdd * 7) - sumEven) % 10;
    final eleventhDigit =
        (digits.take(10).reduce((a, b) => a + b)) % 10;

    // Algoritmaya tam uyan veya standart demo kimlik numaraları (12345678901, 11111111110 vb.)
    final isAlgorithmValid =
        digits[9] == tenthDigit && digits[10] == eleventhDigit;
    final isDemoTc = tc == '12345678901' || tc == '11111111110';

    return isAlgorithmValid || isDemoTc;
  }

  /// Giriş işlemini doğrular ve yürütür
  Future<bool> login() async {
    final tc = value.tc.trim();
    final password = value.password.trim();

    // 1. T.C. Kimlik No Alanı Kontrolleri
    if (tc.isEmpty) {
      value = value.copyWith(
        status: PatientLoginStatus.failure,
        errorMessage: 'Lütfen T.C. Kimlik Numaranızı giriniz.',
        shouldRedirectToRegister: false,
      );
      return false;
    }

    if (tc.length != 11) {
      value = value.copyWith(
        status: PatientLoginStatus.failure,
        errorMessage:
            'T.C. Kimlik Numarası tam 11 haneden oluşmalıdır.',
        shouldRedirectToRegister: true, // Geçersiz girişte kayıt önerilir
      );
      return false;
    }

    if (!_isValidTc(tc)) {
      value = value.copyWith(
        status: PatientLoginStatus.failure,
        errorMessage:
            'Geçersiz T.C. Kimlik Numarası. Lütfen kontrol ediniz veya kayıt olunuz.',
        shouldRedirectToRegister: true,
      );
      return false;
    }

    // 2. Şifre Alanı Kontrolleri
    if (password.isEmpty) {
      value = value.copyWith(
        status: PatientLoginStatus.failure,
        errorMessage: 'Lütfen şifrenizi giriniz.',
        shouldRedirectToRegister: false,
      );
      return false;
    }

    if (password.length < 6) {
      value = value.copyWith(
        status: PatientLoginStatus.failure,
        errorMessage: 'Şifreniz en az 6 karakter olmalıdır.',
        shouldRedirectToRegister: false,
      );
      return false;
    }

    // Yüklenme durumunu başlat
    value = value.copyWith(
      status: PatientLoginStatus.loading,
      clearErrorMessage: true,
      shouldRedirectToRegister: false,
    );

    // Ağ simülasyonu
    await Future<void>.delayed(const Duration(milliseconds: 750));

    // Kayıtlı hasta ve kimlik kontrolü
    final patient = _authRepository.authenticate(tc, password);

    if (patient == null) {
      final isRegistered = _authRepository.isTcRegistered(tc);
      value = value.copyWith(
        status: PatientLoginStatus.failure,
        errorMessage: isRegistered
            ? 'Şifreniz hatalı. Lütfen kontrol edip tekrar deneyiniz.'
            : 'Girdiğiniz T.C. Kimlik No ile kayıtlı bir hasta hesabı bulunamadı. Lütfen kayıt oluşturunuz.',
        shouldRedirectToRegister: !isRegistered, // Kayıtsız ise kayıt yönlendirmesi aktif
      );
      return false;
    }

    // Başarılı giriş
    _authenticatedPatient = patient;
    value = value.copyWith(
      status: PatientLoginStatus.success,
      clearErrorMessage: true,
      shouldRedirectToRegister: false,
    );
    return true;
  }
}
