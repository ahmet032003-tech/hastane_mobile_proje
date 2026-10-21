import 'package:flutter/foundation.dart';
import 'department_model.dart';
import 'doctor_model.dart';
import 'hospital_model.dart';
import 'time_slot_model.dart';

/// Randevu sihirbazı durum modeli (Immutable)
@immutable
class BookingState {
  /// Aktif adım (0: Hastane, 1: Bölüm, 2: Doktor, 3: Tarih/Saat)
  final int currentStep;

  /// 1. Adım: Seçilen Hastane
  final HospitalModel? selectedHospital;

  /// 2. Adım: Seçilen Poliklinik/Bölüm
  final DepartmentModel? selectedDepartment;

  /// 3. Adım: Seçilen Hekim
  final DoctorModel? selectedDoctor;

  /// 4. Adım: Seçilen Randevu Tarihi
  final DateTime? selectedDate;

  /// 4. Adım: Seçilen Saat Slotu
  final TimeSlotModel? selectedTimeSlot;

  /// Arama sorgusu
  final String searchQuery;

  /// Onaylama işlemi yükleniyor durumu
  final bool isSubmitting;

  /// Randevunun başarıyla onaylanma durumu
  final bool isConfirmed;

  /// Onaylanan randevu takip numarası
  final String? confirmedAppointmentId;

  /// Hata veya bilgilendirme mesajı
  final String? errorMessage;

  const BookingState({
    this.currentStep = 0,
    this.selectedHospital,
    this.selectedDepartment,
    this.selectedDoctor,
    this.selectedDate,
    this.selectedTimeSlot,
    this.searchQuery = '',
    this.isSubmitting = false,
    this.isConfirmed = false,
    this.confirmedAppointmentId,
    this.errorMessage,
  });

  /// Bir sonraki adıma geçilip geçilemeyeceğini kontrol eder
  bool get canProceed {
    switch (currentStep) {
      case 0:
        return selectedHospital != null;
      case 1:
        return selectedDepartment != null;
      case 2:
        return selectedDoctor != null;
      case 3:
        return selectedDate != null &&
            selectedTimeSlot != null &&
            !selectedTimeSlot!.isBooked;
      default:
        return false;
    }
  }

  /// Tüm 4 adımın seçimleri eksiksiz mi kontrolü
  bool get isReadyForConfirmation =>
      selectedHospital != null &&
      selectedDepartment != null &&
      selectedDoctor != null &&
      selectedDate != null &&
      selectedTimeSlot != null &&
      !selectedTimeSlot!.isBooked;

  BookingState copyWith({
    int? currentStep,
    HospitalModel? selectedHospital,
    DepartmentModel? selectedDepartment,
    DoctorModel? selectedDoctor,
    DateTime? selectedDate,
    TimeSlotModel? selectedTimeSlot,
    String? searchQuery,
    bool? isSubmitting,
    bool? isConfirmed,
    String? confirmedAppointmentId,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BookingState(
      currentStep: currentStep ?? this.currentStep,
      selectedHospital: selectedHospital ?? this.selectedHospital,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      searchQuery: searchQuery ?? this.searchQuery,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      confirmedAppointmentId:
          confirmedAppointmentId ?? this.confirmedAppointmentId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookingState &&
        other.currentStep == currentStep &&
        other.selectedHospital == selectedHospital &&
        other.selectedDepartment == selectedDepartment &&
        other.selectedDoctor == selectedDoctor &&
        other.selectedDate == selectedDate &&
        other.selectedTimeSlot == selectedTimeSlot &&
        other.searchQuery == searchQuery &&
        other.isSubmitting == isSubmitting &&
        other.isConfirmed == isConfirmed &&
        other.confirmedAppointmentId == confirmedAppointmentId &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return currentStep.hashCode ^
        selectedHospital.hashCode ^
        selectedDepartment.hashCode ^
        selectedDoctor.hashCode ^
        selectedDate.hashCode ^
        selectedTimeSlot.hashCode ^
        searchQuery.hashCode ^
        isSubmitting.hashCode ^
        isConfirmed.hashCode ^
        confirmedAppointmentId.hashCode ^
        errorMessage.hashCode;
  }
}
