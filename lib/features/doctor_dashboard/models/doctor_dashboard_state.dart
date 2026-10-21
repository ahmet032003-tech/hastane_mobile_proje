import 'package:flutter/foundation.dart';

/// Doktor Dashboard ve Poliklinik Masası Durum Modeli (SKILL.md 2.2 & 2.3)
@immutable
class DoctorDashboardState {
  final String doctorName;
  final String doctorTitle;
  final String clinicName;

  /// Muayene durumu anahtarı: true = Açık, false = Mola
  final bool isExamOpen;

  // Operasyon Metrikleri
  final int totalAppointments;
  final int completedExaminations;
  final int waitingPatients;

  // Sıradaki Hasta Bilgisi
  final String nextPatientName;
  final String nextPatientTime;
  final String nextPatientComplaint;
  final int nextPatientQueueNumber;
  final String nextPatientTc;

  /// Sıradaki hastanın muayenesinin devam edip etmediği
  final bool isExamInProgress;

  /// Alt Menü Sekmesi (0: Randevu Listesi, 1: E-Reçete, 2: İstem Merkezi, 3: Doktor Profili)
  final int selectedMenuIndex;

  const DoctorDashboardState({
    this.doctorName = 'Emre Çetin',
    this.doctorTitle = 'Doç. Dr.',
    this.clinicName = 'Kardiyoloji Polikliniği 1',
    this.isExamOpen = true,
    this.totalAppointments = 24,
    this.completedExaminations = 15,
    this.waitingPatients = 9,
    this.nextPatientName = 'Fatma Şahin',
    this.nextPatientTime = '14:15',
    this.nextPatientComplaint =
        'Göğüste sıkışma hissi, efor dispnesi ve sol kolda uyuşma',
    this.nextPatientQueueNumber = 16,
    this.nextPatientTc = '24819582014',
    this.isExamInProgress = false,
    this.selectedMenuIndex = 0,
  });

  String get fullDoctorName => '$doctorTitle $doctorName';

  DoctorDashboardState copyWith({
    String? doctorName,
    String? doctorTitle,
    String? clinicName,
    bool? isExamOpen,
    int? totalAppointments,
    int? completedExaminations,
    int? waitingPatients,
    String? nextPatientName,
    String? nextPatientTime,
    String? nextPatientComplaint,
    int? nextPatientQueueNumber,
    String? nextPatientTc,
    bool? isExamInProgress,
    int? selectedMenuIndex,
  }) {
    return DoctorDashboardState(
      doctorName: doctorName ?? this.doctorName,
      doctorTitle: doctorTitle ?? this.doctorTitle,
      clinicName: clinicName ?? this.clinicName,
      isExamOpen: isExamOpen ?? this.isExamOpen,
      totalAppointments: totalAppointments ?? this.totalAppointments,
      completedExaminations:
          completedExaminations ?? this.completedExaminations,
      waitingPatients: waitingPatients ?? this.waitingPatients,
      nextPatientName: nextPatientName ?? this.nextPatientName,
      nextPatientTime: nextPatientTime ?? this.nextPatientTime,
      nextPatientComplaint:
          nextPatientComplaint ?? this.nextPatientComplaint,
      nextPatientQueueNumber:
          nextPatientQueueNumber ?? this.nextPatientQueueNumber,
      nextPatientTc: nextPatientTc ?? this.nextPatientTc,
      isExamInProgress: isExamInProgress ?? this.isExamInProgress,
      selectedMenuIndex: selectedMenuIndex ?? this.selectedMenuIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DoctorDashboardState &&
        other.doctorName == doctorName &&
        other.doctorTitle == doctorTitle &&
        other.clinicName == clinicName &&
        other.isExamOpen == isExamOpen &&
        other.totalAppointments == totalAppointments &&
        other.completedExaminations == completedExaminations &&
        other.waitingPatients == waitingPatients &&
        other.nextPatientName == nextPatientName &&
        other.nextPatientTime == nextPatientTime &&
        other.nextPatientComplaint == nextPatientComplaint &&
        other.nextPatientQueueNumber == nextPatientQueueNumber &&
        other.nextPatientTc == nextPatientTc &&
        other.isExamInProgress == isExamInProgress &&
        other.selectedMenuIndex == selectedMenuIndex;
  }

  @override
  int get hashCode {
    return doctorName.hashCode ^
        doctorTitle.hashCode ^
        clinicName.hashCode ^
        isExamOpen.hashCode ^
        totalAppointments.hashCode ^
        completedExaminations.hashCode ^
        waitingPatients.hashCode ^
        nextPatientName.hashCode ^
        nextPatientTime.hashCode ^
        nextPatientComplaint.hashCode ^
        nextPatientQueueNumber.hashCode ^
        nextPatientTc.hashCode ^
        isExamInProgress.hashCode ^
        selectedMenuIndex.hashCode;
  }
}
