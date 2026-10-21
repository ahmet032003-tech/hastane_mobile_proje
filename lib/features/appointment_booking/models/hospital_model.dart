import 'package:flutter/foundation.dart';

/// Randevu akışı için Hastane modeli
@immutable
class HospitalModel {
  final String id;
  final String name;
  final double distanceKm;
  final String address;
  final double rating;

  const HospitalModel({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.address,
    required this.rating,
  });

  static List<HospitalModel> mockList() {
    return const [
      HospitalModel(
        id: 'hosp_01',
        name: 'MedAuto Kadıköy Şehir Hastanesi',
        distanceKm: 1.8,
        address: 'Caferağa Mah. Moda Cad. No:12 Kadıköy',
        rating: 4.9,
      ),
      HospitalModel(
        id: 'hosp_02',
        name: 'MedAuto Üsküdar Eğitim ve Araştırma Hastanesi',
        distanceKm: 3.4,
        address: 'Mimar Sinan Mah. Hakimiyet-i Milliye Cad. Üsküdar',
        rating: 4.8,
      ),
      HospitalModel(
        id: 'hosp_03',
        name: 'MedAuto Ataşehir İhtisas Tıp Merkezi',
        distanceKm: 5.6,
        address: 'Barbaros Mah. Mor Sümbül Sok. Ataşehir',
        rating: 4.7,
      ),
      HospitalModel(
        id: 'hosp_04',
        name: 'MedAuto Maltepe Bölge Hastanesi',
        distanceKm: 8.2,
        address: 'Bağlarbaşı Mah. İnönü Cad. Maltepe',
        rating: 4.6,
      ),
      HospitalModel(
        id: 'hosp_05',
        name: 'MedAuto Kartal Dr. Lütfi Kırdar Kompleksi',
        distanceKm: 12.0,
        address: 'Cevizli Mah. Şemsi Denizer Cad. Kartal',
        rating: 4.8,
      ),
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HospitalModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
