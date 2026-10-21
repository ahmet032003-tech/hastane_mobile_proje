import 'package:flutter/foundation.dart';

/// Test kategorisi (Radyoloji veya Laboratuvar Tahlili)
enum TestCategory {
  radiology,
  laboratory,
}

/// Laboratuvar test parametre sonuç modeli
@immutable
class LabItemResult {
  final String parameter;
  final String value;
  final String unit;
  final String referenceRange;
  final bool isNormal;
  final String statusLabel;

  const LabItemResult({
    required this.parameter,
    required this.value,
    required this.unit,
    required this.referenceRange,
    required this.isNormal,
    required this.statusLabel,
  });
}

/// Radyoloji ve Tahlil Veri Modeli (SKILL.md 1.6)
@immutable
class MedicalTestModel {
  final String id;
  final String testName;
  final TestCategory category;
  final DateTime testDate;
  final String requestingDoctor;
  final String requestingDoctorBranch;

  /// İstem gerekçesi / klinik amacı
  final String requestReason;

  /// Uzman / hekim açık klinik rapor yorumu
  final String doctorClinicalComment;

  /// Radyoloji görüntüsü başlığı veya açıklaması
  final String? radiologyImageTitle;

  /// Laboratuvar parametre sonuçları (Laboratuvar testleri için)
  final List<LabItemResult>? labResults;

  /// Rapor durumu (örn: "Rapor Onaylandı")
  final String status;

  const MedicalTestModel({
    required this.id,
    required this.testName,
    required this.category,
    required this.testDate,
    required this.requestingDoctor,
    required this.requestingDoctorBranch,
    required this.requestReason,
    required this.doctorClinicalComment,
    this.radiologyImageTitle,
    this.labResults,
    required this.status,
  });

  bool get isRadiology => category == TestCategory.radiology;

  String get categoryName => isRadiology ? 'Radyoloji' : 'Laboratuvar Tahlili';

  String get formattedDate {
    final d = testDate.day.toString().padLeft(2, '0');
    final m = testDate.month.toString().padLeft(2, '0');
    final y = testDate.year;
    return '$d.$m.$y';
  }

  static List<MedicalTestModel> mockList() {
    return [
      MedicalTestModel(
        id: 'test_01',
        testName: 'Akciğer PA Grafisi (Röntgen)',
        category: TestCategory.radiology,
        testDate: DateTime(2026, 10, 14),
        requestingDoctor: 'Uzm. Dr. Selin Kaya',
        requestingDoctorBranch: 'Göğüs Hastalıkları',
        requestReason:
            'Alerjik astım zemininde gelişen nefes darlığı, kronik öksürük ve göğüs ağrısı şikayeti nedeniyle parankimal ve plevral patolojilerin dışlanması amacıyla istendi.',
        doctorClinicalComment:
            'Kardiyotorasik indeks fizyolojik sınırlar içerisindedir. Mediastinal vasküler yapılar normal konfigürasyondadır. Her iki hemitoraksta kostofrenik ve kardiyofrenik sinüsler açıktır. Akciğer parankim alanlarında aktif infiltrasyon, kitle veya konsolidasyon saptanmamıştır. Trakea orta hattadır.',
        radiologyImageTitle: 'Akciğer PA Projeksiyon Dijital Röntgen',
        status: 'Rapor Onaylandı',
      ),
      MedicalTestModel(
        id: 'test_02',
        testName: 'Hemogram & Biyokimya Paneli',
        category: TestCategory.laboratory,
        testDate: DateTime(2026, 10, 12),
        requestingDoctor: 'Doç. Dr. Emre Çetin',
        requestingDoctorBranch: 'Kardiyoloji Polikliniği',
        requestReason:
            'Hipertansiyon takibi ve rutin kardiyometabolik risk profilinin, elektrolit dengesi ve böbrek fonksiyonlarının incelenmesi amacıyla istendi.',
        doctorClinicalComment:
            'Tam kan sayımı parametreleri normal sınırlardadır. Açlık kan glukozu ve lipid profili kontrol altında olup, kreatinin ve elektrolit değerleri normal fizyolojik aralıktadır. Akut enfeksiyon veya anemi bulgusu saptanmamıştır.',
        labResults: const [
          LabItemResult(
            parameter: 'WBC (Beyaz Kan Hücresi)',
            value: '7.2',
            unit: '10^3/µL',
            referenceRange: '4.0 - 10.0',
            isNormal: true,
            statusLabel: 'Normal',
          ),
          LabItemResult(
            parameter: 'Hemoglobin (HGB)',
            value: '14.1',
            unit: 'g/dL',
            referenceRange: '12.0 - 16.0',
            isNormal: true,
            statusLabel: 'Normal',
          ),
          LabItemResult(
            parameter: 'Açlık Kan Şekeri (Glukoz)',
            value: '95',
            unit: 'mg/dL',
            referenceRange: '70 - 100',
            isNormal: true,
            statusLabel: 'Normal',
          ),
          LabItemResult(
            parameter: 'Kreatinin (Serum)',
            value: '0.84',
            unit: 'mg/dL',
            referenceRange: '0.6 - 1.1',
            isNormal: true,
            statusLabel: 'Normal',
          ),
          LabItemResult(
            parameter: 'LDL Kolesterol',
            value: '118',
            unit: 'mg/dL',
            referenceRange: '< 100',
            isNormal: false,
            statusLabel: 'Hafif Yüksek',
          ),
        ],
        status: 'Sonuçlandı (Onaylı)',
      ),
      MedicalTestModel(
        id: 'test_03',
        testName: 'Transtorasik Ekokardiyografi (EKO)',
        category: TestCategory.radiology,
        testDate: DateTime(2026, 8, 22),
        requestingDoctor: 'Doç. Dr. Emre Çetin',
        requestingDoctorBranch: 'Kardiyoloji Polikliniği',
        requestReason:
            'Esansiyel hipertansiyon zemininde sol ventrikül hipertrofisi ve kapak fonksiyonlarının renkli doppler ultrasonografi ile değerlendirilmesi amacıyla istendi.',
        doctorClinicalComment:
            'Sol ventrikül sistolik fonksiyonları korunmuştur (EF: %62). Ciddi duvar hareket kusuru izlenmedi. Hafif derecede mitral yetersizliği saptandı, hemodinamik olarak anlamlı değildir. Perikardiyal efüzyon saptanmamıştır. 1 yıl sonra kontrol önerilir.',
        radiologyImageTitle: 'EKO Renkli Doppler 4 Odacık Kesiti',
        status: 'Rapor Onaylandı',
      ),
      MedicalTestModel(
        id: 'test_04',
        testName: 'Serum B12 ve Folat Düzeyi',
        category: TestCategory.laboratory,
        testDate: DateTime(2026, 6, 18),
        requestingDoctor: 'Uzm. Dr. Murat Demir',
        requestingDoctorBranch: 'İç Hastalıkları (Dahiliye)',
        requestReason:
            'Kronik yorgunluk, halsizlik ve konsantrasyon güçlüğü şikayetleri nedeniyle vitamin düzeylerinin tetkiki amacıyla istendi.',
        doctorClinicalComment:
            'B12 vitamini düzeyi referans aralığının alt sınırında izlenmiş olup replasman tedavisi (Benexol B12) başlanmıştır. Folat ve demir parametreleri normal sınırlardadır.',
        labResults: const [
          LabItemResult(
            parameter: 'Vitamin B12',
            value: '178',
            unit: 'pg/mL',
            referenceRange: '200 - 900',
            isNormal: false,
            statusLabel: 'Düşük',
          ),
          LabItemResult(
            parameter: 'Folat (Folik Asit)',
            value: '8.4',
            unit: 'ng/mL',
            referenceRange: '3.1 - 20.5',
            isNormal: true,
            statusLabel: 'Normal',
          ),
          LabItemResult(
            parameter: 'Ferritin',
            value: '48',
            unit: 'ng/mL',
            referenceRange: '15 - 150',
            isNormal: true,
            statusLabel: 'Normal',
          ),
        ],
        status: 'Sonuçlandı (Onaylı)',
      ),
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalTestModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
