import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../patient_auth/services/patient_auth_repository.dart';
import '../models/patient_model.dart';

/// Kişisel Sağlık Verileri Bölümü
/// Boy, Kilo, Hesaplanan BMI ve Aktif Kullanılan İlaç Sayısı kutucukları
/// Boy ve Kilo elle düzenlenebilir.
class PatientHealthMetrics extends StatelessWidget {
  final PatientModel patient;
  final ValueChanged<PatientModel>? onPatientUpdated;

  const PatientHealthMetrics({
    super.key,
    required this.patient,
    this.onPatientUpdated,
  });

  /// Boy ve Kilo Düzenleme Modalını Açar
  void _showEditMetricsModal(BuildContext context, {bool initialFocusOnWeight = false}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return _EditHealthMetricsSheet(
          patient: patient,
          initialFocusOnWeight: initialFocusOnWeight,
          onSave: (updatedPatient) {
            onPatientUpdated?.call(updatedPatient);
            PatientAuthRepository.instance.updatePatientData(updatedPatient);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Boy ve kilo bilgileriniz başarıyla güncellendi.'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: AppColors.primaryLight,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Kişisel Sağlık Verileri',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Elle Düzenle Hızlı Aksiyon Butonu
            InkWell(
              key: const ValueKey('edit_health_metrics_button'),
              borderRadius: BorderRadius.circular(8),
              onTap: () => _showEditMetricsModal(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primaryLight.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      size: 16,
                      color: AppColors.primaryLight,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Düzenle',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // 1. Boy Kutucuğu (Tıklanabilir ve düzenlenebilir)
            Expanded(
              child: _MetricCard(
                title: 'Boy',
                value: '${patient.heightCm.toInt()} cm',
                subtitle: 'Standart • Düzenle ✎',
                icon: Icons.straighten_rounded,
                accentColor: AppColors.primaryLight,
                isEditable: true,
                onTap: () => _showEditMetricsModal(context, initialFocusOnWeight: false),
              ),
            ),
            const SizedBox(width: 12),
            // 2. Kilo Kutucuğu (Tıklanabilir ve düzenlenebilir)
            Expanded(
              child: _MetricCard(
                title: 'Kilo',
                value: '${patient.weightKg} kg',
                subtitle: 'Güncel • Düzenle ✎',
                icon: Icons.monitor_weight_outlined,
                accentColor: AppColors.secondary,
                isEditable: true,
                onTap: () => _showEditMetricsModal(context, initialFocusOnWeight: true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // 3. Hesaplanan BMI Kutucuğu
            Expanded(
              child: _MetricCard(
                title: 'Vücut Kitle İndeksi',
                value: '${patient.bmi}',
                unit: 'kg/m²',
                subtitle: patient.bmiCategory,
                icon: Icons.speed_rounded,
                accentColor: AppColors.accentTeal,
              ),
            ),
            const SizedBox(width: 12),
            // 4. Aktif Kullanılan İlaç Sayısı Kutucuğu
            Expanded(
              child: _MetricCard(
                title: 'Aktif İlaç',
                value: '${patient.activeMedicationCount}',
                unit: 'Reçeteli',
                subtitle: 'Düzenli Kullanım',
                icon: Icons.medication_outlined,
                accentColor: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool isEditable;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.title,
    required this.value,
    this.unit,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.isEditable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isEditable
                  ? accentColor.withValues(alpha: 0.35)
                  : AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isEditable) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.touch_app_rounded,
                          size: 12,
                          color: accentColor.withValues(alpha: 0.7),
                        ),
                      ],
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (unit != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      unit!,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Boy ve Kilo Düzenleme Formu Alt Sayfası
class _EditHealthMetricsSheet extends StatefulWidget {
  final PatientModel patient;
  final bool initialFocusOnWeight;
  final ValueChanged<PatientModel> onSave;

  const _EditHealthMetricsSheet({
    required this.patient,
    required this.initialFocusOnWeight,
    required this.onSave,
  });

  @override
  State<_EditHealthMetricsSheet> createState() => _EditHealthMetricsSheetState();
}

class _EditHealthMetricsSheetState extends State<_EditHealthMetricsSheet> {
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final FocusNode _heightFocus;
  late final FocusNode _weightFocus;

  double _height = 0;
  double _weight = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _height = widget.patient.heightCm;
    _weight = widget.patient.weightKg;

    _heightController = TextEditingController(text: _height.toInt().toString());
    _weightController = TextEditingController(text: _weight.toString());

    _heightFocus = FocusNode();
    _weightFocus = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialFocusOnWeight) {
        _weightFocus.requestFocus();
      } else {
        _heightFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _heightFocus.dispose();
    _weightFocus.dispose();
    super.dispose();
  }

  double get _calculatedBmi {
    if (_height <= 0) return 0.0;
    final hm = _height / 100.0;
    return double.parse((_weight / (hm * hm)).toStringAsFixed(1));
  }

  String get _calculatedBmiCategory {
    final value = _calculatedBmi;
    if (value <= 0) return '-';
    if (value < 18.5) return 'Zayıf';
    if (value < 25.0) return 'Normal / İdeal';
    if (value < 30.0) return 'Fazla Kilolu';
    return 'Obez';
  }

  Color get _calculatedBmiColor {
    final value = _calculatedBmi;
    if (value >= 18.5 && value < 25.0) return AppColors.success;
    if (value >= 25.0 && value < 30.0) return AppColors.warning;
    return AppColors.error;
  }

  void _updateHeight(double val) {
    setState(() {
      _height = val.clamp(50, 250);
      _heightController.text = _height.toInt().toString();
      _errorMessage = null;
    });
  }

  void _updateWeight(double val) {
    setState(() {
      _weight = double.parse((val.clamp(20, 300)).toStringAsFixed(1));
      _weightController.text = _weight.toString();
      _errorMessage = null;
    });
  }

  void _handleSave() {
    final parsedHeight = double.tryParse(_heightController.text.trim()) ?? 0;
    final parsedWeight = double.tryParse(_weightController.text.trim()) ?? 0;

    if (parsedHeight < 50 || parsedHeight > 250) {
      setState(() {
        _errorMessage = 'Lütfen geçerli bir boy değeri giriniz (50 - 250 cm).';
      });
      return;
    }

    if (parsedWeight < 20 || parsedWeight > 300) {
      setState(() {
        _errorMessage = 'Lütfen geçerli bir kilo değeri giriniz (20 - 300 kg).';
      });
      return;
    }

    final updated = widget.patient.copyWith(
      heightCm: parsedHeight,
      weightKg: parsedWeight,
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sürükleme Tutamacı
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Başlık
            const Row(
              children: [
                Icon(
                  Icons.edit_calendar_rounded,
                  color: AppColors.primaryLight,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'Boy ve Kilo Güncelle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Girilen yeni boy ve kilo değerlerine göre Vücut Kitle İndeksiniz (VKİ) anında otomatik olarak güncellenecektir.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Hata Bildirimi (Varsa)
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.error),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // 1. Boy Giriş Alanı & Butonları
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Boy (cm)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // -1 cm Butonu
                      IconButton.filledTonal(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () => _updateHeight(_height - 1),
                      ),
                      const SizedBox(width: 8),
                      // Boy Input
                      Expanded(
                        child: TextField(
                          controller: _heightController,
                          focusNode: _heightFocus,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            suffixText: 'cm',
                            suffixStyle: const TextStyle(
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val) ?? _height;
                            setState(() => _height = parsed);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // +1 cm Butonu
                      IconButton.filledTonal(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () => _updateHeight(_height + 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. Kilo Giriş Alanı & Butonları
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kilo (kg)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // -0.5 kg Butonu
                      IconButton.filledTonal(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () => _updateWeight(_weight - 0.5),
                      ),
                      const SizedBox(width: 8),
                      // Kilo Input
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          focusNode: _weightFocus,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            suffixText: 'kg',
                            suffixStyle: const TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (val) {
                            final parsed = double.tryParse(val) ?? _weight;
                            setState(() => _weight = parsed);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // +0.5 kg Butonu
                      IconButton.filledTonal(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () => _updateWeight(_weight + 0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 3. Canlı VKİ (Vücut Kitle İndeksi) Hesaplama Önizlemesi
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _calculatedBmiColor.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _calculatedBmiColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.speed_rounded,
                      color: _calculatedBmiColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Yeniden Hesaplanan VKİ:',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '$_calculatedBmi kg/m²',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _calculatedBmiColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _calculatedBmiCategory,
                                style: TextStyle(
                                  color: _calculatedBmiColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 4. Kaydet ve Vazgeç Butonları
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Vazgeç'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton.icon(
                      key: const ValueKey('save_health_metrics_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      icon: const Icon(Icons.check_rounded, color: Colors.white),
                      label: const Text(
                        'Değerleri Kaydet',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _handleSave,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
