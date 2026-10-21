import 'package:flutter/foundation.dart';

/// Randevu saat slotu modeli (Sabah/Öğle ve dolu saatler pasif kontrolü)
@immutable
class TimeSlotModel {
  final String time;
  final bool isMorning;
  final bool isBooked;

  const TimeSlotModel({
    required this.time,
    required this.isMorning,
    required this.isBooked,
  });

  static List<TimeSlotModel> mockMorningSlots() {
    return const [
      TimeSlotModel(time: '09:00', isMorning: true, isBooked: false),
      TimeSlotModel(time: '09:30', isMorning: true, isBooked: true), // Dolu slot (pasif)
      TimeSlotModel(time: '10:00', isMorning: true, isBooked: false),
      TimeSlotModel(time: '10:30', isMorning: true, isBooked: false),
      TimeSlotModel(time: '11:00', isMorning: true, isBooked: true), // Dolu slot (pasif)
      TimeSlotModel(time: '11:30', isMorning: true, isBooked: false),
    ];
  }

  static List<TimeSlotModel> mockAfternoonSlots() {
    return const [
      TimeSlotModel(time: '13:30', isMorning: false, isBooked: false),
      TimeSlotModel(time: '14:00', isMorning: false, isBooked: false),
      TimeSlotModel(time: '14:30', isMorning: false, isBooked: true), // Dolu slot (pasif)
      TimeSlotModel(time: '15:00', isMorning: false, isBooked: false),
      TimeSlotModel(time: '15:30', isMorning: false, isBooked: false),
      TimeSlotModel(time: '16:00', isMorning: false, isBooked: true), // Dolu slot (pasif)
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlotModel &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          isMorning == other.isMorning &&
          isBooked == other.isBooked;

  @override
  int get hashCode => time.hashCode ^ isMorning.hashCode ^ isBooked.hashCode;
}
