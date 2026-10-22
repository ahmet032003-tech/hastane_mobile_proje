import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../medications/services/medication_repository.dart';
import '../../models/doctor_patient_appointment.dart';

/// E-Reçete Masası (SKILL.md 2.3: İlaç yazma, dozaj belirleme ve hasta profiline atama)
class DoctorEPrescriptionTab extends StatefulWidget {
  final String patientName;
  final String patientTc;
  final List<DoctorPatientAppointment>? availablePatients;
  final String doctorName;
  final String clinicName;

  const DoctorEPrescriptionTab({
    super.key,
    required this.patientName,
    required this.patientTc,
    this.availablePatients,
    this.doctorName = 'Doç. Dr. Emre Çetin',
    this.clinicName = 'Kardiyoloji Polikliniği 1',
  });

  @override
  State<DoctorEPrescriptionTab> createState() => _DoctorEPrescriptionTabState();
}

class _DoctorEPrescriptionTabState extends State<DoctorEPrescriptionTab> {
  final TextEditingController _medicineController = TextEditingController();
  String _selectedFrequency = 'Günde 1 Defa';
  String _selectedHunger = 'Tok Karnına';
  int _boxCount = 1;

  late String _currentPatientName;
  late String _currentPatientTc;

  bool _isAssignedSuccess = false;

  final List<Map<String, String>> _prescribedList = [
    {
      'name': 'Kopidogrel 75 mg Film Tablet',
      'dosage': '1x1 Sabah Tok',
      'boxes': '1 Kutu',
      'status': 'Bekliyor',
    },
    {
      'name': 'Atorvastatin 20 mg',
      'dosage': '1x1 Gece Tok',
      'boxes': '1 Kutu',
      'status': 'Bekliyor',
    },
  ];

  static const List<String> _quickSuggestions = [
    'Atorvastatin 20 mg',
    'Coraspin 100 mg',
    'Augmentin 1000 mg',
    'Nexium 40 mg',
    'Parol 500 mg',
    'Beloc ZOK 50 mg',
  ];

  @override
  void initState() {
    super.initState();
    _currentPatientName = widget.patientName;
    _currentPatientTc = widget.patientTc;
  }

  @override
  void didUpdateWidget(covariant DoctorEPrescriptionTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.patientTc != oldWidget.patientTc &&
        widget.patientTc.isNotEmpty &&
        widget.patientTc != '-') {
      _currentPatientName = widget.patientName;
      _currentPatientTc = widget.patientTc;
    }
  }

  @override
  void dispose() {
    _medicineController.dispose();
    super.dispose();
  }

  void _addMedicine() {
    final name = _medicineController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _prescribedList.add({
        'name': name,
        'dosage': '$_selectedFrequency ($_selectedHunger)',
        'boxes': '$_boxCount Kutu',
        'status': 'Bekliyor',
      });
      _medicineController.clear();
      _isAssignedSuccess = false;
    });
  }

  void _handleConfirmAndAssignPrescription() {
    if (_medicineController.text.trim().isNotEmpty) {
      _addMedicine();
    }

    if (_prescribedList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen reçeteye en az bir ilaç ekleyiniz.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Hasta kimlik doğrulaması
    final effectiveTc =
        _currentPatientTc.isNotEmpty && _currentPatientTc != '-'
            ? _currentPatientTc
            : '12345678901';

    // MedicationRepository üzerinden ilaçları hastaya aktif olarak ata
    final assignedMeds = MedicationRepository.instance.prescribeMedications(
      patientTc: effectiveTc,
      patientName: _currentPatientName,
      medicines: _prescribedList,
      doctorName: widget.doctorName,
      doctorBranch: widget.clinicName,
      defaultDisease: 'Poliklinik Tedavisi',
    );

    setState(() {
      for (final item in _prescribedList) {
        item['status'] = 'Aktif';
      }
      _isAssignedSuccess = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'E-Reçete onaylandı! ${assignedMeds.length} adet ilaç $_currentPatientName profiline aktif ilaç olarak atandı.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // 1. Hasta Bilgi ve Seçim Başlığı
        _buildPatientSelectionCard(),
        const SizedBox(height: 16),

        // 2. İlaç Ekleme Masası Formu
        _buildPrescriptionFormCard(),
        const SizedBox(height: 16),

        // 3. Reçetedeki İlaçlar Listesi Başlığı
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reçete İlaç Listesi',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_isAssignedSuccess)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 13, color: AppColors.success),
                    SizedBox(width: 4),
                    Text(
                      'Profile Aktif Olarak İşlendi',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (_prescribedList.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text(
                'Reçetede henüz ilaç bulunmuyor. Yukarıdaki formdan ilaç ekleyebilirsiniz.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ..._prescribedList.map((item) {
            final isItemActive = item['status'] == 'Aktif';
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isItemActive
                      ? AppColors.success.withValues(alpha: 0.45)
                      : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isItemActive
                          ? AppColors.success.withValues(alpha: 0.15)
                          : AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.medication_rounded,
                      color: isItemActive
                          ? AppColors.success
                          : AppColors.primaryLight,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item['name']!,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isItemActive
                                    ? AppColors.success.withValues(alpha: 0.2)
                                    : AppColors.warning.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isItemActive ? '✓ Aktif İlaç' : '● Reçetede',
                                style: TextStyle(
                                  color: isItemActive
                                      ? AppColors.success
                                      : AppColors.warning,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item['dosage']} • ${item['boxes']}',
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        size: 18, color: AppColors.error),
                    onPressed: () {
                      setState(() {
                        _prescribedList.remove(item);
                        _isAssignedSuccess = false;
                      });
                    },
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 16),

        // 4. E-Reçeteyi İmzala ve Hastaya Ata Butonu
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            key: const ValueKey('confirm_prescription_button'),
            icon: const Icon(Icons.verified_rounded, size: 20),
            label: const Text(
              'E-İmza ile Reçeteyi Onayla & Hastaya Ata',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
            onPressed: _handleConfirmAndAssignPrescription,
          ),
        ),
      ],
    );
  }

  Widget _buildPatientSelectionCard() {
    final patients = widget.availablePatients ?? [];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_pin_rounded,
                  color: AppColors.primaryLight, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reçete Yazılan Hasta: $_currentPatientName',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'T.C. $_currentPatientTc • E-Reçete No: E-REC-89241',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (patients.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Hasta Değiştir:',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      isExpanded: true,
                      dropdownColor: AppColors.surface,
                      value: patients.any((p) => p.tc == _currentPatientTc)
                          ? _currentPatientTc
                          : patients.first.tc,
                      style: const TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      items: patients.map((p) {
                        return DropdownMenuItem<String>(
                          value: p.tc,
                          child: Text('${p.patientName} (${p.tc})'),
                        );
                      }).toList(),
                      onChanged: (newTc) {
                        if (newTc == null) return;
                        final selected =
                            patients.firstWhere((p) => p.tc == newTc);
                        setState(() {
                          _currentPatientTc = selected.tc;
                          _currentPatientName = selected.patientName;
                          _isAssignedSuccess = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrescriptionFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'İlaç & Dozaj Belirleme',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // İlaç Arama/Yazma Alanı
          TextField(
            controller: _medicineController,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'İlaç etken maddesi veya adı yazın...',
              prefixIcon: const Icon(Icons.medication_liquid_outlined,
                  color: AppColors.primaryLight, size: 20),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded,
                    color: AppColors.success),
                onPressed: _addMedicine,
              ),
            ),
            onSubmitted: (_) => _addMedicine(),
          ),
          const SizedBox(height: 10),

          // Hızlı Öneri İlaç Chipleri
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _quickSuggestions.map((suggestion) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _medicineController.text = suggestion;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    '+ $suggestion',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Dozaj & Tokluk Seçicileri
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedFrequency,
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'Dozaj Sıklığı',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'Günde 1 Defa', child: Text('Günde 1 Defa')),
                    DropdownMenuItem(
                        value: 'Günde 2 Defa', child: Text('Günde 2 Defa')),
                    DropdownMenuItem(
                        value: 'Günde 3 Defa', child: Text('Günde 3 Defa')),
                    DropdownMenuItem(
                        value: 'Gerektiğinde', child: Text('Gerektiğinde')),
                  ],
                  onChanged: (v) => setState(() => _selectedFrequency = v!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedHunger,
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'Aç/Tok Durumu',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'Tok Karnına', child: Text('Tok Karnına')),
                    DropdownMenuItem(
                        value: 'Aç Karnına', child: Text('Aç Karnına')),
                    DropdownMenuItem(
                        value: 'Yemek Arasında', child: Text('Yemek Arasında')),
                    DropdownMenuItem(
                        value: 'Fark Etmez', child: Text('Fark Etmez')),
                  ],
                  onChanged: (v) => setState(() => _selectedHunger = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Kutu Sayısı Seçici
          Row(
            children: [
              const Text(
                'Kutu Sayısı:',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              ...[1, 2, 3].map((boxes) {
                final isSelected = _boxCount == boxes;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('$boxes Kutu'),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _boxCount = boxes),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 14),

          // İlacı Listeye Ekle Butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('İlacı Reçeteye Ekle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceSecondary,
                foregroundColor: AppColors.primaryLight,
                side: const BorderSide(color: AppColors.primaryLight),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _addMedicine,
            ),
          ),
        ],
      ),
    );
  }
}
