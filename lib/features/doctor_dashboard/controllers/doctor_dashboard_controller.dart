import 'package:flutter/foundation.dart';
import '../models/doctor_dashboard_state.dart';

/// Doktor Poliklinik Masası ve operasyon metriklerini yöneten ValueNotifier controller
class DoctorDashboardController extends ValueNotifier<DoctorDashboardState> {
  DoctorDashboardController({DoctorDashboardState? initialState})
      : super(initialState ?? const DoctorDashboardState());

  /// Muayene durumu anahtarını değiştir (Açık / Mola)
  void toggleExamStatus(bool isOpen) {
    value = value.copyWith(isExamOpen: isOpen);
  }

  /// Sıradaki hastanın muayenesini başlat
  void startCurrentExamination() {
    value = value.copyWith(isExamInProgress: true);
  }

  /// Aktif muayeneyi tamamla, metrikleri güncelle ve sıradakini çağır
  void finishCurrentExamination() {
    final newCompleted = value.completedExaminations + 1;
    final newWaiting = value.waitingPatients > 0 ? value.waitingPatients - 1 : 0;

    value = value.copyWith(
      completedExaminations: newCompleted,
      waitingPatients: newWaiting,
      isExamInProgress: false,
      nextPatientQueueNumber: value.nextPatientQueueNumber + 1,
      nextPatientName: 'Hasan Yurtseven',
      nextPatientTime: '14:30',
      nextPatientComplaint: 'Rutin hipertansiyon ve EKG kontrolü',
      nextPatientTc: '38192049182',
    );
  }

  /// Alt menü sekmesini değiştir (0: Randevu Listesi, 1: E-Reçete, 2: İstem, 3: Profil)
  void setMenuIndex(int index) {
    if (index >= 0 && index <= 3 && value.selectedMenuIndex != index) {
      value = value.copyWith(selectedMenuIndex: index);
    }
  }
}
