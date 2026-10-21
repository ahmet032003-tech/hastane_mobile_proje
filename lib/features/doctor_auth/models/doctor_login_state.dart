import 'package:flutter/foundation.dart';

/// Doktor Giriş Durum Modeli (SKILL.md 2.1)
@immutable
class DoctorLoginState {
  /// T.C. Kimlik veya Diploma Tescil Numarası
  final String diplomaOrTc;

  /// Hastane Kurum Kodu (örn: ASH-3401)
  final String institutionCode;

  /// Doktor şifresi
  final String password;

  /// Şifre görünürlük durumu
  final bool isPasswordVisible;

  /// Giriş işlemi yükleniyor mu
  final bool isLoading;

  /// Giriş başarılı mı
  final bool isSuccess;

  /// Hata veya bilgilendirme mesajı
  final String? errorMessage;

  const DoctorLoginState({
    this.diplomaOrTc = '',
    this.institutionCode = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  DoctorLoginState copyWith({
    String? diplomaOrTc,
    String? institutionCode,
    String? password,
    bool? isPasswordVisible,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DoctorLoginState(
      diplomaOrTc: diplomaOrTc ?? this.diplomaOrTc,
      institutionCode: institutionCode ?? this.institutionCode,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DoctorLoginState &&
        other.diplomaOrTc == diplomaOrTc &&
        other.institutionCode == institutionCode &&
        other.password == password &&
        other.isPasswordVisible == isPasswordVisible &&
        other.isLoading == isLoading &&
        other.isSuccess == isSuccess &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return diplomaOrTc.hashCode ^
        institutionCode.hashCode ^
        password.hashCode ^
        isPasswordVisible.hashCode ^
        isLoading.hashCode ^
        isSuccess.hashCode ^
        errorMessage.hashCode;
  }
}
