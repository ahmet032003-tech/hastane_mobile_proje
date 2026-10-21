import 'package:flutter/foundation.dart';

/// Hasta temel ve klinik verilerini temsil eden model
@immutable
class PatientModel {
  final String id;
  final String fullName;
  final String tc;
  final String? photoUrl;
  final String birthDate;
  final String gender;
  final String bloodType;
  final String phone;
  final String email;
  final String address;

  // Son muayene ve ziyaret bilgisi
  final String lastVisitDate;
  final String lastDoctorName;
  final String lastDoctorBranch;

  // Sağlık metrikleri
  final double heightCm;
  final double weightKg;
  final int activeMedicationCount;

  // Aktif tanılar / hastalıklar
  final List<String> activeDiseases;

  const PatientModel({
    required this.id,
    required this.fullName,
    required this.tc,
    this.photoUrl,
    required this.birthDate,
    required this.gender,
    required this.bloodType,
    required this.phone,
    required this.email,
    required this.address,
    required this.lastVisitDate,
    required this.lastDoctorName,
    required this.lastDoctorBranch,
    required this.heightCm,
    required this.weightKg,
    required this.activeMedicationCount,
    required this.activeDiseases,
  });

  /// Vücut Kitle İndeksi (BMI) hesaplaması: kg / (m * m)
  double get bmi {
    if (heightCm <= 0) return 0.0;
    final heightM = heightCm / 100.0;
    return double.parse((weightKg / (heightM * heightM)).toStringAsFixed(1));
  }

  /// BMI klinik durum açıklaması
  String get bmiCategory {
    final value = bmi;
    if (value < 18.5) return 'Zayıf';
    if (value < 25.0) return 'Normal / İdeal';
    if (value < 30.0) return 'Fazla Kilolu';
    return 'Obez';
  }

  /// Varsayılan demo hasta verisi
  factory PatientModel.mock() {
    return const PatientModel(
      id: 'patient_001',
      fullName: 'Ayşe Yılmaz',
      tc: '12345678901',
      birthDate: '14 Mayıs 1988',
      gender: 'Kadın',
      bloodType: 'A Rh(+)',
      phone: '+90 (532) 555 12 34',
      email: 'ayse.yilmaz@medauto.health',
      address: 'Caferağa Mah. Moda Cad. No:42 Kadıköy / İstanbul',
      lastVisitDate: '12 Ekim 2026',
      lastDoctorName: 'Doç. Dr. Emre Çetin',
      lastDoctorBranch: 'Kardiyoloji Polikliniği',
      heightCm: 168.0,
      weightKg: 62.5,
      activeMedicationCount: 3,
      activeDiseases: [
        'Esansiyel Hipertansiyon',
        'Alerjik Astım',
        'Tip 2 Diyabet Riski',
        'B12 Vitamini Eksikliği',
      ],
    );
  }

  PatientModel copyWith({
    String? id,
    String? fullName,
    String? tc,
    String? photoUrl,
    String? birthDate,
    String? gender,
    String? bloodType,
    String? phone,
    String? email,
    String? address,
    String? lastVisitDate,
    String? lastDoctorName,
    String? lastDoctorBranch,
    double? heightCm,
    double? weightKg,
    int? activeMedicationCount,
    List<String>? activeDiseases,
  }) {
    return PatientModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      tc: tc ?? this.tc,
      photoUrl: photoUrl ?? this.photoUrl,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      lastDoctorName: lastDoctorName ?? this.lastDoctorName,
      lastDoctorBranch: lastDoctorBranch ?? this.lastDoctorBranch,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activeMedicationCount:
          activeMedicationCount ?? this.activeMedicationCount,
      activeDiseases: activeDiseases ?? this.activeDiseases,
    );
  }
}
