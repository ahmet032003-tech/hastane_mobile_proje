import 'package:flutter/foundation.dart';
import '../../patient_home/models/patient_model.dart';

/// Hasta kayıt durumları
enum PatientRegisterStatus {
  initial,
  loading,
  success,
  failure,
}

/// Hasta kayıt formu durumu (Immutable State)
@immutable
class PatientRegisterState {
  final String tc;
  final String fullName;
  final String phone;
  final String email;
  final String birthDate;
  final String gender;
  final String bloodType;
  final String address;
  final String password;
  final String passwordConfirm;
  final bool isPasswordVisible;
  final bool isPasswordConfirmVisible;
  final bool isKvkkAccepted;
  final PatientRegisterStatus status;
  final String? errorMessage;
  final PatientModel? registeredPatient;

  const PatientRegisterState({
    this.tc = '',
    this.fullName = '',
    this.phone = '',
    this.email = '',
    this.birthDate = '',
    this.gender = 'Kadın',
    this.bloodType = 'A Rh(+)',
    this.address = '',
    this.password = '',
    this.passwordConfirm = '',
    this.isPasswordVisible = false,
    this.isPasswordConfirmVisible = false,
    this.isKvkkAccepted = false,
    this.status = PatientRegisterStatus.initial,
    this.errorMessage,
    this.registeredPatient,
  });

  PatientRegisterState copyWith({
    String? tc,
    String? fullName,
    String? phone,
    String? email,
    String? birthDate,
    String? gender,
    String? bloodType,
    String? address,
    String? password,
    String? passwordConfirm,
    bool? isPasswordVisible,
    bool? isPasswordConfirmVisible,
    bool? isKvkkAccepted,
    PatientRegisterStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
    PatientModel? registeredPatient,
  }) {
    return PatientRegisterState(
      tc: tc ?? this.tc,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      address: address ?? this.address,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isPasswordConfirmVisible:
          isPasswordConfirmVisible ?? this.isPasswordConfirmVisible,
      isKvkkAccepted: isKvkkAccepted ?? this.isKvkkAccepted,
      status: status ?? this.status,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      registeredPatient: registeredPatient ?? this.registeredPatient,
    );
  }

  bool get isLoading => status == PatientRegisterStatus.loading;
  bool get isSuccess => status == PatientRegisterStatus.success;
  bool get isFailure => status == PatientRegisterStatus.failure;
  bool get isTcValidLength => tc.length == 11;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PatientRegisterState &&
        other.tc == tc &&
        other.fullName == fullName &&
        other.phone == phone &&
        other.email == email &&
        other.birthDate == birthDate &&
        other.gender == gender &&
        other.bloodType == bloodType &&
        other.address == address &&
        other.password == password &&
        other.passwordConfirm == passwordConfirm &&
        other.isPasswordVisible == isPasswordVisible &&
        other.isPasswordConfirmVisible == isPasswordConfirmVisible &&
        other.isKvkkAccepted == isKvkkAccepted &&
        other.status == status &&
        other.errorMessage == errorMessage &&
        other.registeredPatient == registeredPatient;
  }

  @override
  int get hashCode {
    return tc.hashCode ^
        fullName.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        birthDate.hashCode ^
        gender.hashCode ^
        bloodType.hashCode ^
        address.hashCode ^
        password.hashCode ^
        passwordConfirm.hashCode ^
        isPasswordVisible.hashCode ^
        isPasswordConfirmVisible.hashCode ^
        isKvkkAccepted.hashCode ^
        status.hashCode ^
        errorMessage.hashCode ^
        registeredPatient.hashCode;
  }
}
