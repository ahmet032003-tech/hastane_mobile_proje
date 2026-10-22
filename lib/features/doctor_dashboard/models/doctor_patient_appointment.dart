import 'package:flutter/foundation.dart';

/// Doktor Poliklinik Randevu Öğesi Modeli
@immutable
class DoctorPatientAppointment {
  final int queueNumber;
  final String patientName;
  final String appointmentTime;
  final String complaint;
  final String tc;
  final String status;
  final bool isCompleted;
  final bool isActive;

  const DoctorPatientAppointment({
    required this.queueNumber,
    required this.patientName,
    required this.appointmentTime,
    required this.complaint,
    required this.tc,
    this.status = 'Bekliyor',
    this.isCompleted = false,
    this.isActive = false,
  });

  DoctorPatientAppointment copyWith({
    int? queueNumber,
    String? patientName,
    String? appointmentTime,
    String? complaint,
    String? tc,
    String? status,
    bool? isCompleted,
    bool? isActive,
  }) {
    return DoctorPatientAppointment(
      queueNumber: queueNumber ?? this.queueNumber,
      patientName: patientName ?? this.patientName,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      complaint: complaint ?? this.complaint,
      tc: tc ?? this.tc,
      status: status ?? this.status,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DoctorPatientAppointment &&
        other.queueNumber == queueNumber &&
        other.patientName == patientName &&
        other.appointmentTime == appointmentTime &&
        other.complaint == complaint &&
        other.tc == tc &&
        other.status == status &&
        other.isCompleted == isCompleted &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return queueNumber.hashCode ^
        patientName.hashCode ^
        appointmentTime.hashCode ^
        complaint.hashCode ^
        tc.hashCode ^
        status.hashCode ^
        isCompleted.hashCode ^
        isActive.hashCode;
  }
}
