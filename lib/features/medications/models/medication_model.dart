import 'package:flutter/foundation.dart';

/// İlaç ve Reçete Veri Modeli (SKILL.md 1.5)
@immutable
class MedicationModel {
  final String id;
  final String name;
  final DateTime prescribedDate;
  final String expiryDate;
  final String doctorName;
  final String doctorBranch;
  final String diseaseReason;
  final String usageInstructions;
  final String dosage;
  final int boxCount;
  final String barcode;
  final String instructionsDetail;

  const MedicationModel({
    required this.id,
    required this.name,
    required this.prescribedDate,
    required this.expiryDate,
    required this.doctorName,
    required this.doctorBranch,
    required this.diseaseReason,
    required this.usageInstructions,
    required this.dosage,
    required this.boxCount,
    required this.barcode,
    required this.instructionsDetail,
  });

  /// Tarih formatı (GG.AA.YYYY)
  String get formattedPrescribedDate {
    final d = prescribedDate.day.toString().padLeft(2, '0');
    final m = prescribedDate.month.toString().padLeft(2, '0');
    final y = prescribedDate.year;
    return '$d.$m.$y';
  }

  static List<MedicationModel> mockList() {
    return [
      MedicationModel(
        id: 'med_01',
        name: 'Kopidogrel 75 mg Film Tablet',
        prescribedDate: DateTime(2026, 10, 12),
        expiryDate: '10.11.2027',
        doctorName: 'Doç. Dr. Emre Çetin',
        doctorBranch: 'Kardiyoloji Polikliniği',
        diseaseReason: 'Esansiyel Hipertansiyon',
        usageInstructions: 'Günde 1 Defa (Tok Karnına)',
        dosage: '1x1 Tablet - Sabah Tok',
        boxCount: 2,
        barcode: '8699525010012',
        instructionsDetail:
            'Her gün sabah kahvaltısından sonra 1 bardak su ile çiğnenmeden yutulmalıdır. Tansiyon ve pıhtılaşma profilaksisi için düzenli kullanılmalıdır.',
      ),
      MedicationModel(
        id: 'med_02',
        name: 'Ventolin İnhaler 100 mcg',
        prescribedDate: DateTime(2026, 9, 28),
        expiryDate: '15.01.2028',
        doctorName: 'Uzm. Dr. Selin Kaya',
        doctorBranch: 'Göğüs Hastalıkları',
        diseaseReason: 'Alerjik Astım',
        usageInstructions: 'Gerektiğinde 2 Doz (Aç/Tok Fark Etmez)',
        dosage: 'Nefes darlığı atağında 2 puf',
        boxCount: 1,
        barcode: '8699508520210',
        instructionsDetail:
            'İnhaleri kullanmadan önce iyice çalkalayınız. Derin bir nefes verdikten sonra ağızlığı dudaklarınızla kavrayarak nefes alma anında sıkınız ve 10 saniye nefesinizi tutunuz.',
      ),
      MedicationModel(
        id: 'med_03',
        name: 'Benexol B12 Kaplı Tablet',
        prescribedDate: DateTime(2026, 8, 15),
        expiryDate: '22.04.2027',
        doctorName: 'Uzm. Dr. Murat Demir',
        doctorBranch: 'İç Hastalıkları (Dahiliye)',
        diseaseReason: 'B12 Vitamini Eksikliği',
        usageInstructions: 'Günde 1 Tablet (Sabah Tok)',
        dosage: '1x1 Tablet - Kahvaltı Sonrası',
        boxCount: 1,
        barcode: '8699546010023',
        instructionsDetail:
            'B1, B6 ve B12 vitamin kombinasyonudur. Sinir iletimi ve halsizlik semptomları için sabah tok karna alınmalıdır.',
      ),
      MedicationModel(
        id: 'med_04',
        name: 'Glukofaj 1000 mg Film Tablet',
        prescribedDate: DateTime(2026, 6, 20),
        expiryDate: '05.08.2027',
        doctorName: 'Prof. Dr. Selin Yıldırım',
        doctorBranch: 'İç Hastalıkları (Endokrinoloji)',
        diseaseReason: 'Tip 2 Diyabet Riski',
        usageInstructions: 'Günde 2 Defa (Yemek Sırasında)',
        dosage: '2x1 Tablet - Sabah/Akşam Yemekte',
        boxCount: 2,
        barcode: '8699508090515',
        instructionsDetail:
            'İnsülin duyarlılığını artırmak ve kan şekerini dengelemek amacıyla yemeklerle birlikte veya yemekten hemen sonra alınmalıdır.',
      ),
      MedicationModel(
        id: 'med_05',
        name: 'Muscoflex Duo Jel 30 g',
        prescribedDate: DateTime(2026, 4, 10),
        expiryDate: '18.12.2026',
        doctorName: 'Prof. Dr. Ahmet Karahan',
        doctorBranch: 'Ortopedi ve Travmatoloji',
        diseaseReason: 'Lomber Disk Bozukluğu',
        usageInstructions: 'Günde 3 Defa Bölgesel Masaj',
        dosage: 'İnce tabaka halinde haricen',
        boxCount: 1,
        barcode: '8699569340015',
        instructionsDetail:
            'Ağrılı bel ve kas bölgesine hafif masaj yapılarak günde 3 kez uygulanır. Açık yaralara sürülmemelidir.',
      ),
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
