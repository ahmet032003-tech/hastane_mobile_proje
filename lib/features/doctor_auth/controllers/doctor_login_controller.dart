import 'package:flutter/foundation.dart';
import '../models/doctor_login_state.dart';

/// Doktor giriş mantığı ve doğrulamalarını yöneten ValueNotifier controller
class DoctorLoginController extends ValueNotifier<DoctorLoginState> {
  DoctorLoginController({DoctorLoginState? initialState})
      : super(initialState ?? const DoctorLoginState());

  void setDiplomaOrTc(String value) {
    this.value = this.value.copyWith(
          diplomaOrTc: value.trim(),
          clearError: true,
        );
  }

  void setInstitutionCode(String value) {
    this.value = this.value.copyWith(
          institutionCode: value.trim().toUpperCase(),
          clearError: true,
        );
  }

  void setPassword(String value) {
    this.value = this.value.copyWith(
          password: value,
          clearError: true,
        );
  }

  void togglePasswordVisibility() {
    value = value.copyWith(
      isPasswordVisible: !value.isPasswordVisible,
    );
  }

  /// Doktor girişini doğrular ve sisteme giriş yapar
  Future<bool> login() async {
    final diploma = value.diplomaOrTc.trim();
    final instCode = value.institutionCode.trim();
    final pwd = value.password.trim();

    if (diploma.isEmpty) {
      value = value.copyWith(
        errorMessage: 'Lütfen T.C. veya Diploma Tescil Numaranızı giriniz.',
      );
      return false;
    }

    if (instCode.isEmpty) {
      value = value.copyWith(
        errorMessage: 'Lütfen hastane Kurum Kodunu giriniz (örn: ASH-34).',
      );
      return false;
    }

    if (pwd.isEmpty) {
      value = value.copyWith(
        errorMessage: 'Lütfen hekim şifrenizi giriniz.',
      );
      return false;
    }

    value = value.copyWith(
      isLoading: true,
      clearError: true,
    );

    await Future<void>.delayed(const Duration(milliseconds: 700));

    // Kayıtlı demo hekim hesabı doğrulaması
    final isDemoDoc = (diploma == '123456' && pwd == '123456') ||
        (diploma == '12345678901' && pwd == '123456');

    if (!isDemoDoc && !instCode.startsWith('ASH')) {
      value = value.copyWith(
        isLoading: false,
        errorMessage:
            'Girdiğiniz kurum kodu veya tescil numarası ile yetkili hekim kaydı bulunamadı.',
      );
      return false;
    }

    value = value.copyWith(
      isLoading: false,
      isSuccess: true,
      clearError: true,
    );
    return true;
  }
}
