import 'package:flutter/foundation.dart';
import '../../appointment_booking/services/appointment_repository.dart';
import '../models/doctor_dashboard_state.dart';

/// Doktor Poliklinik Masası ve operasyon metriklerini yöneten ValueNotifier controller
class DoctorDashboardController extends ValueNotifier<DoctorDashboardState> {
  final AppointmentRepository _appointmentRepository;
  bool _isDisposed = false;

  DoctorDashboardController({
    DoctorDashboardState? initialState,
    AppointmentRepository? appointmentRepository,
  })  : _appointmentRepository =
            appointmentRepository ?? AppointmentRepository.instance,
        super(initialState ?? const DoctorDashboardState()) {
    _syncFromRepository();
    _appointmentRepository.appointmentsNotifier.addListener(_syncFromRepository);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _appointmentRepository.appointmentsNotifier.removeListener(_syncFromRepository);
    super.dispose();
  }

  /// AppointmentRepository'den yeni alınan hasta randevularını senkronize et
  void _syncFromRepository() {
    if (_isDisposed) return;

    final repoList = _appointmentRepository.appointments;
    final currentApptKeys =
        value.appointments.map((a) => '${a.tc}-${a.appointmentTime}').toSet();

    final newItems = repoList
        .where((a) => !currentApptKeys.contains('${a.tc}-${a.appointmentTime}'))
        .toList();

    if (newItems.isEmpty) return;

    final updatedAppointments =
        List<DoctorPatientAppointment>.from(value.appointments)
          ..addAll(newItems);
    final updatedQueue =
        List<DoctorPatientAppointment>.from(value.upcomingQueue);

    final newWaiting = value.waitingPatients + newItems.length;
    final newTotal = value.totalAppointments + newItems.length;

    // Eğer şu an bekleyen/aktif hasta kalmamışsa, yeni gelen hastayı direkt sıradaki yap
    if (!value.hasNextPatient && newItems.isNotEmpty) {
      final firstNew = newItems.first;
      final restNew = newItems.sublist(1);
      updatedQueue.addAll(restNew);

      value = value.copyWith(
        hasNextPatient: true,
        nextPatientName: firstNew.patientName,
        nextPatientTime: firstNew.appointmentTime,
        nextPatientComplaint: firstNew.complaint,
        nextPatientQueueNumber: firstNew.queueNumber,
        nextPatientTc: firstNew.tc,
        upcomingQueue: updatedQueue,
        appointments: updatedAppointments,
        totalAppointments: newTotal,
        waitingPatients: newWaiting,
      );
    } else {
      updatedQueue.addAll(newItems);
      value = value.copyWith(
        upcomingQueue: updatedQueue,
        appointments: updatedAppointments,
        totalAppointments: newTotal,
        waitingPatients: newWaiting,
      );
    }
  }

  /// Muayene durumu anahtarını değiştir (Açık / Mola)
  void toggleExamStatus(bool isOpen) {
    value = value.copyWith(isExamOpen: isOpen);
  }

  /// Sıradaki hastanın muayenesini başlat
  void startCurrentExamination() {
    final updatedAppointments = value.appointments.map((item) {
      if (item.patientName == value.nextPatientName) {
        return item.copyWith(
          status: 'Muayene Odasında',
          isActive: true,
        );
      }
      return item;
    }).toList();

    value = value.copyWith(
      isExamInProgress: true,
      appointments: updatedAppointments,
    );
  }

  /// Aktif muayeneyi tamamla, metrikleri güncelle ve sıradakini çağır
  void finishCurrentExamination() {
    final newCompleted = value.completedExaminations + 1;
    final currentPatient = value.nextPatientName;

    // Tamamlanan hastayı listede güncelle
    final updatedAppointments = value.appointments.map((item) {
      if (item.patientName == currentPatient) {
        return item.copyWith(
          status: 'Tamamlandı',
          isCompleted: true,
          isActive: false,
        );
      }
      return item;
    }).toList();

    if (value.upcomingQueue.isNotEmpty) {
      // Kuyruktaki sıradaki hastayı al
      final nextPatient = value.upcomingQueue.first;
      final remainingQueue = value.upcomingQueue.sublist(1);

      // Yeni çağrılan hastayı randevu listesinde aktif yap
      final finalizedAppointments = updatedAppointments.map((item) {
        if (item.patientName == nextPatient.patientName) {
          return item.copyWith(
            status: 'Kapıda Bekliyor',
            isActive: true,
          );
        }
        return item;
      }).toList();

      final newWaiting =
          value.waitingPatients > 0 ? value.waitingPatients - 1 : 0;

      value = value.copyWith(
        completedExaminations: newCompleted,
        waitingPatients: newWaiting,
        isExamInProgress: false,
        hasNextPatient: true,
        nextPatientQueueNumber: nextPatient.queueNumber,
        nextPatientName: nextPatient.patientName,
        nextPatientTime: nextPatient.appointmentTime,
        nextPatientComplaint: nextPatient.complaint,
        nextPatientTc: nextPatient.tc,
        upcomingQueue: remainingQueue,
        appointments: finalizedAppointments,
      );
    } else {
      // Poliklinikte hiç hasta kalmadı
      value = value.copyWith(
        completedExaminations: newCompleted,
        waitingPatients: 0,
        isExamInProgress: false,
        hasNextPatient: false,
        nextPatientQueueNumber: value.nextPatientQueueNumber + 1,
        nextPatientName: '',
        nextPatientTime: '',
        nextPatientComplaint: '',
        nextPatientTc: '',
        upcomingQueue: const [],
        appointments: updatedAppointments,
      );
    }
  }

  /// Poliklinik kuyruğunu varsayılan başlangıç durumuna sıfırla
  void resetQueue() {
    _appointmentRepository.reset();
    value = const DoctorDashboardState();
  }

  /// Alt menü sekmesini değiştir (0: Randevu Listesi, 1: E-Reçete, 2: İstem, 3: Profil)
  void setMenuIndex(int index) {
    if (index >= 0 && index <= 3 && value.selectedMenuIndex != index) {
      value = value.copyWith(selectedMenuIndex: index);
    }
  }
}
