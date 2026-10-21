import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// E-Reçete Masası (SKILL.md 2.3: İlaç yazma ve dozaj belirleme)
class DoctorEPrescriptionTab extends StatefulWidget {
  final String patientName;
  final String patientTc;

  const DoctorEPrescriptionTab({
    super.key,
    required this.patientName,
    required this.patientTc,
  });

  @override
  State<DoctorEPrescriptionTab> createState() => _DoctorEPrescriptionTabState();
}

class _DoctorEPrescriptionTabState extends State<DoctorEPrescriptionTab> {
  final TextEditingController _medicineController = TextEditingController();
  String _selectedFrequency = 'Günde 1 Defa';
  String _selectedHunger = 'Tok Karnına';
  final int _boxCount = 1;

  final List<Map<String, String>> _prescribedList = [
    {
      'name': 'Kopidogrel 75 mg Film Tablet',
      'dosage': '1x1 Sabah Tok',
      'boxes': '1 Kutu',
    },
    {
      'name': 'Atorvastatin 20 mg',
      'dosage': '1x1 Gece Tok',
      'boxes': '1 Kutu',
    },
  ];

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
      });
      _medicineController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // Hasta Bilgi Başlığı
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.person_pin_rounded,
                  color: AppColors.primaryLight, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reçete Yazılan Hasta: ${widget.patientName}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'T.C. ${widget.patientTc} • E-Reçete No: E-REC-89241',
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
        ),
        const SizedBox(height: 16),

        // İlaç Ekleme Masası Formu
        Container(
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
                      ],
                      onChanged: (v) => setState(() => _selectedHunger = v!),
                    ),
                  ),
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
                  ),
                  onPressed: _addMedicine,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Reçeteye Eklenen İlaçlar Listesi
        const Text(
          'Reçete İlaç Listesi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        ..._prescribedList.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.medication_rounded,
                      color: AppColors.primaryLight, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name']!,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
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
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 18, color: AppColors.error),
                  onPressed: () {
                    setState(() => _prescribedList.remove(item));
                  },
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),

        // E-Reçeteyi İmzala ve Kaydet Butonu
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.verified_rounded, size: 20),
            label: const Text(
              'E-İmza ile Reçeteyi Onayla & Gönder',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('E-Reçete onaylandı ve Medula sistemine iletildi.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
