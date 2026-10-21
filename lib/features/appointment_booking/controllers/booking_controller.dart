import 'package:flutter/foundation.dart';
import '../models/booking_state.dart';
import '../models/department_model.dart';
import '../models/doctor_model.dart';
import '../models/hospital_model.dart';
import '../models/time_slot_model.dart';

/// Randevu akışını yöneten `ValueNotifier<BookingState>` controller
class BookingController extends ValueNotifier<BookingState> {
  BookingController({BookingState? initialState})
      : super(initialState ?? const BookingState());

  /// 1. Adım: Hastane Seçimi
  void selectHospital(HospitalModel hospital) {
    // Hastane değişirse bağımlı alt seçimleri sıfırla
    final isDifferent = value.selectedHospital?.id != hospital.id;

    value = value.copyWith(
      selectedHospital: hospital,
      selectedDepartment: isDifferent ? null : value.selectedDepartment,
      selectedDoctor: isDifferent ? null : value.selectedDoctor,
      selectedTimeSlot: isDifferent ? null : value.selectedTimeSlot,
      clearError: true,
    );
  }

  /// 2. Adım: Poliklinik/Bölüm Seçimi
  void selectDepartment(DepartmentModel department) {
    final isDifferent = value.selectedDepartment?.id != department.id;

    value = value.copyWith(
      selectedDepartment: department,
      selectedDoctor: isDifferent ? null : value.selectedDoctor,
      selectedTimeSlot: isDifferent ? null : value.selectedTimeSlot,
      clearError: true,
    );
  }

  /// 3. Adım: Hekim Seçimi
  void selectDoctor(DoctorModel doctor) {
    final isDifferent = value.selectedDoctor?.id != doctor.id;

    value = value.copyWith(
      selectedDoctor: doctor,
      selectedTimeSlot: isDifferent ? null : value.selectedTimeSlot,
      clearError: true,
    );
  }

  /// 4. Adım: Tarih Seçimi
  void selectDate(DateTime date) {
    value = value.copyWith(
      selectedDate: date,
      clearError: true,
    );
  }

  /// 4. Adım: Saat Slotu Seçimi
  void selectTimeSlot(TimeSlotModel slot) {
    if (slot.isBooked) return; // Dolu saat seçilemez

    value = value.copyWith(
      selectedTimeSlot: slot,
      clearError: true,
    );
  }

  /// Arama sorgusu güncelleme
  void setSearchQuery(String query) {
    value = value.copyWith(searchQuery: query);
  }

  /// Bir sonraki sihirbaz adımına geç
  bool nextStep() {
    if (!value.canProceed) {
      value = value.copyWith(
        errorMessage: 'Lütfen bu adımdaki seçiminizi tamamlayınız.',
      );
      return false;
    }

    if (value.currentStep < 3) {
      value = value.copyWith(
        currentStep: value.currentStep + 1,
        searchQuery: '',
        clearError: true,
      );
      return true;
    }
    return false;
  }

  /// Bir önceki sihirbaz adımına dön
  bool previousStep() {
    if (value.currentStep > 0) {
      value = value.copyWith(
        currentStep: value.currentStep - 1,
        searchQuery: '',
        clearError: true,
      );
      return true;
    }
    return false;
  }

  /// Belirli bir adıma doğrudan geç
  void goToStep(int step) {
    if (step >= 0 && step <= 3) {
      // Önceki adımlar seçili olmadan ileri atlamayı sınırla
      if (step > 0 && value.selectedHospital == null) return;
      if (step > 1 && value.selectedDepartment == null) return;
      if (step > 2 && value.selectedDoctor == null) return;

      value = value.copyWith(
        currentStep: step,
        searchQuery: '',
        clearError: true,
      );
    }
  }

  /// Randevuyu onayla ve sisteme kaydet
  Future<bool> confirmAppointment() async {
    if (!value.isReadyForConfirmation) {
      value = value.copyWith(
        errorMessage: 'Lütfen tüm randevu adımlarını eksiksiz tamamlayınız.',
      );
      return false;
    }

    value = value.copyWith(
      isSubmitting: true,
      clearError: true,
    );

    // Ağ simülasyonu
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final randomTrackingNumber =
        'RND-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    value = value.copyWith(
      isSubmitting: false,
      isConfirmed: true,
      confirmedAppointmentId: randomTrackingNumber,
      clearError: true,
    );

    return true;
  }

  /// Sihirbazı sıfırlar
  void reset() {
    value = const BookingState();
  }
}
