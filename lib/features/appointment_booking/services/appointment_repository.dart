import 'package:flutter/foundation.dart';
import '../../doctor_dashboard/models/doctor_dashboard_state.dart';

/// Randevu yönetim havuzu (Doktor & Hasta randevu senkronizasyon servisi)
class AppointmentRepository {
  static final AppointmentRepository instance = AppointmentRepository._();

  AppointmentRepository._() {
    _initDefaults();
  }

  factory AppointmentRepository() => instance;

  final ValueNotifier<List<DoctorPatientAppointment>> appointmentsNotifier =
      ValueNotifier<List<DoctorPatientAppointment>>([]);

  void _initDefaults() {
    appointmentsNotifier.value =
        List<DoctorPatientAppointment>.from(DoctorDashboardState.defaultAppointments);
  }

  List<DoctorPatientAppointment> get appointments => appointmentsNotifier.value;

  /// Hastanın aldığı yeni randevuyu sisteme ve doktor ekranına ekler
  DoctorPatientAppointment addAppointment({
    required String patientName,
    required String tc,
    required String appointmentTime,
    required String complaint,
    String doctorName = 'Emre Çetin',
  }) {
    final currentList =
        List<DoctorPatientAppointment>.from(appointmentsNotifier.value);

    // Mevcut en yüksek sıra numarasını bul ve 1 artır
    int maxQueue = 18;
    for (final appt in currentList) {
      if (appt.queueNumber > maxQueue) {
        maxQueue = appt.queueNumber;
      }
    }

    final newAppointment = DoctorPatientAppointment(
      queueNumber: maxQueue + 1,
      patientName: patientName,
      appointmentTime: appointmentTime,
      complaint: complaint,
      tc: tc,
      status: 'Kapıda Bekliyor',
      isCompleted: false,
      isActive: false,
    );

    currentList.add(newAppointment);
    appointmentsNotifier.value = currentList;

    return newAppointment;
  }

  void reset() {
    _initDefaults();
  }
}
