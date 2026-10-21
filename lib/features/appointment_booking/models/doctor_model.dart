import 'package:flutter/foundation.dart';

/// Randevu akışı için Doktor modeli (SKILL.md: fotoğraf, unvan, değerlendirme puanı)
@immutable
class DoctorModel {
  final String id;
  final String name;
  final String title;
  final String departmentId;
  final String departmentName;
  final double rating;
  final int reviewCount;
  final String avatarInitials;
  final String? photoUrl;
  final int experienceYears;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.title,
    required this.departmentId,
    required this.departmentName,
    required this.rating,
    required this.reviewCount,
    required this.avatarInitials,
    this.photoUrl,
    required this.experienceYears,
  });

  String get fullTitleAndName => '$title $name';

  static List<DoctorModel> mockList() {
    return const [
      // Kardiyoloji
      DoctorModel(
        id: 'doc_cardio_1',
        name: 'Emre Çetin',
        title: 'Doç. Dr.',
        departmentId: 'dept_cardio',
        departmentName: 'Kardiyoloji',
        rating: 4.9,
        reviewCount: 142,
        avatarInitials: 'EÇ',
        experienceYears: 16,
      ),
      DoctorModel(
        id: 'doc_cardio_2',
        name: 'Zeynep Aksoy',
        title: 'Prof. Dr.',
        departmentId: 'dept_cardio',
        departmentName: 'Kardiyoloji',
        rating: 4.8,
        reviewCount: 98,
        avatarInitials: 'ZA',
        experienceYears: 22,
      ),

      // Dahiliye
      DoctorModel(
        id: 'doc_internal_1',
        name: 'Murat Demir',
        title: 'Uzm. Dr.',
        departmentId: 'dept_internal',
        departmentName: 'İç Hastalıkları (Dahiliye)',
        rating: 4.7,
        reviewCount: 84,
        avatarInitials: 'MD',
        experienceYears: 11,
      ),
      DoctorModel(
        id: 'doc_internal_2',
        name: 'Selin Yıldırım',
        title: 'Prof. Dr.',
        departmentId: 'dept_internal',
        departmentName: 'İç Hastalıkları (Dahiliye)',
        rating: 4.9,
        reviewCount: 176,
        avatarInitials: 'SY',
        experienceYears: 20,
      ),

      // Göz Hastalıkları
      DoctorModel(
        id: 'doc_eye_1',
        name: 'Kaan Öztürk',
        title: 'Doç. Dr.',
        departmentId: 'dept_eye',
        departmentName: 'Göz Hastalıkları',
        rating: 4.8,
        reviewCount: 115,
        avatarInitials: 'KÖ',
        experienceYears: 14,
      ),

      // Nöroloji
      DoctorModel(
        id: 'doc_neuro_1',
        name: 'Berna Erdem',
        title: 'Uzm. Dr.',
        departmentId: 'dept_neuro',
        departmentName: 'Nöroloji',
        rating: 4.9,
        reviewCount: 65,
        avatarInitials: 'BE',
        experienceYears: 9,
      ),

      // Ortopedi
      DoctorModel(
        id: 'doc_ortho_1',
        name: 'Ahmet Karahan',
        title: 'Prof. Dr.',
        departmentId: 'dept_ortho',
        departmentName: 'Ortopedi ve Travmatoloji',
        rating: 4.9,
        reviewCount: 210,
        avatarInitials: 'AK',
        experienceYears: 25,
      ),

      // Göğüs Hastalıkları
      DoctorModel(
        id: 'doc_chest_1',
        name: 'Selin Kaya',
        title: 'Uzm. Dr.',
        departmentId: 'dept_chest',
        departmentName: 'Göğüs Hastalıkları',
        rating: 4.8,
        reviewCount: 92,
        avatarInitials: 'SK',
        experienceYears: 12,
      ),
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
