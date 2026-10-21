import 'package:flutter/foundation.dart';

/// Hasta giriş durumları
enum PatientLoginStatus {
  initial,
  loading,
  success,
  failure,
}

/// Hasta giriş ekranı durum modeli (Immutable State)
@immutable
class PatientLoginState {
  /// 11 haneli T.C. Kimlik Numarası
  final String tc;

  /// Hasta hesap şifresi
  final String password;

  /// Şifre gizleme / gösterme görünürlük bayrağı
  final bool isPasswordVisible;

  /// Giriş işlemi akış durumu
  final PatientLoginStatus status;

  /// Hata veya bilgilendirme mesajı
  final String? errorMessage;

  /// Geçersiz veya kayıtsız girişte kayıt ekranına yönlendirme bayrağı
  final bool shouldRedirectToRegister;

  const PatientLoginState({
    this.tc = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.status = PatientLoginStatus.initial,
    this.errorMessage,
    this.shouldRedirectToRegister = false,
  });

  /// Durumun kopyasını üretip belirli alanları günceller
  PatientLoginState copyWith({
    String? tc,
    String? password,
    bool? isPasswordVisible,
    PatientLoginStatus? status,
    String? errorMessage,
    bool? shouldRedirectToRegister,
    bool clearErrorMessage = false,
  }) {
    return PatientLoginState(
      tc: tc ?? this.tc,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      shouldRedirectToRegister:
          shouldRedirectToRegister ?? this.shouldRedirectToRegister,
    );
  }

  /// Yükleniyor durumu kontrolü
  bool get isLoading => status == PatientLoginStatus.loading;

  /// Başarılı giriş kontrolü
  bool get isSuccess => status == PatientLoginStatus.success;

  /// Hata durumu kontrolü
  bool get isFailure => status == PatientLoginStatus.failure;

  /// T.C. Kimlik Numarası 11 hane mi kontrolü
  bool get isTcValidLength => tc.length == 11;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientLoginState &&
        other.tc == tc &&
        other.password == password &&
        other.isPasswordVisible == isPasswordVisible &&
        other.status == status &&
        other.errorMessage == errorMessage &&
        other.shouldRedirectToRegister == shouldRedirectToRegister;
  }

  @override
  int get hashCode {
    return tc.hashCode ^
        password.hashCode ^
        isPasswordVisible.hashCode ^
        status.hashCode ^
        errorMessage.hashCode ^
        shouldRedirectToRegister.hashCode;
  }

  @override
  String toString() {
    return 'PatientLoginState(tc: $tc, isPasswordVisible: $isPasswordVisible, status: $status, errorMessage: $errorMessage, shouldRedirectToRegister: $shouldRedirectToRegister)';
  }
}
