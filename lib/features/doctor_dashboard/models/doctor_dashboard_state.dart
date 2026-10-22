import 'package:flutter/foundation.dart';
import 'doctor_patient_appointment.dart';

export 'doctor_patient_appointment.dart';

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

  /// Sıradaki hasta var mı? (Bekleyen hasta kalıp kalmadığı kontrolü)
  final bool hasNextPatient;

  /// Sıradaki hastalar kuyruğu
  final List<DoctorPatientAppointment> upcomingQueue;

  /// Günlük hasta akış listesi
  final List<DoctorPatientAppointment> appointments;

  static const List<DoctorPatientAppointment> defaultAppointments = [
    DoctorPatientAppointment(
      queueNumber: 13,
      appointmentTime: '09:00',
      patientName: 'Mehmet Özdemir',
      complaint: 'Rutin EKG kontrolü',
      status: 'Tamamlandı',
      isCompleted: true,
      tc: '10293847561',
    ),
    DoctorPatientAppointment(
      queueNumber: 14,
      appointmentTime: '09:30',
      patientName: 'Ayşe Yılmaz',
      complaint: 'Hipertansiyon ve baş dönmesi',
      status: 'Tamamlandı',
      isCompleted: true,
      tc: '12345678901',
    ),
    DoctorPatientAppointment(
      queueNumber: 15,
      appointmentTime: '10:15',
      patientName: 'Ahmet Demir',
      complaint: 'Göğüs ağrısı ve çarpıntı',
      status: 'Tamamlandı',
      isCompleted: true,
      tc: '48291048591',
    ),
    DoctorPatientAppointment(
      queueNumber: 16,
      appointmentTime: '14:15',
      patientName: 'Fatma Şahin',
      complaint: 'Göğüste sıkışma hissi, efor dispnesi ve sol kolda uyuşma',
      status: 'Kapıda Bekliyor',
      isActive: true,
      tc: '24819582014',
    ),
    DoctorPatientAppointment(
      queueNumber: 17,
      appointmentTime: '14:45',
      patientName: 'Hasan Yurtseven',
      complaint: 'Rutin hipertansiyon ve EKG kontrolü',
      status: 'Kapıda Bekliyor',
      tc: '38192049182',
    ),
    DoctorPatientAppointment(
      queueNumber: 18,
      appointmentTime: '15:15',
      patientName: 'Zeynep Kaya',
      complaint: 'Efor testi değerlendirmesi',
      status: 'Sırada',
      tc: '51203948172',
    ),
  ];

  static const List<DoctorPatientAppointment> defaultUpcomingQueue = [
    DoctorPatientAppointment(
      queueNumber: 17,
      appointmentTime: '14:45',
      patientName: 'Hasan Yurtseven',
      complaint: 'Rutin hipertansiyon ve EKG kontrolü',
      status: 'Kapıda Bekliyor',
      tc: '38192049182',
    ),
    DoctorPatientAppointment(
      queueNumber: 18,
      appointmentTime: '15:15',
      patientName: 'Zeynep Kaya',
      complaint: 'Efor testi değerlendirmesi',
      status: 'Sırada',
      tc: '51203948172',
    ),
  ];

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
    this.hasNextPatient = true,
    this.upcomingQueue = defaultUpcomingQueue,
    this.appointments = defaultAppointments,
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
    bool? hasNextPatient,
    List<DoctorPatientAppointment>? upcomingQueue,
    List<DoctorPatientAppointment>? appointments,
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
      hasNextPatient: hasNextPatient ?? this.hasNextPatient,
      upcomingQueue: upcomingQueue ?? this.upcomingQueue,
      appointments: appointments ?? this.appointments,
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
        other.selectedMenuIndex == selectedMenuIndex &&
        other.hasNextPatient == hasNextPatient &&
        listEquals(other.upcomingQueue, upcomingQueue) &&
        listEquals(other.appointments, appointments);
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
        selectedMenuIndex.hashCode ^
        hasNextPatient.hashCode ^
        upcomingQueue.hashCode ^
        appointments.hashCode;
  }
}
