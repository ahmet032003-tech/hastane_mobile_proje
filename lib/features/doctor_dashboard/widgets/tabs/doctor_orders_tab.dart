import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// İstem Merkezi (SKILL.md 2.3: Tetkik istemi oluşturma ve sonuç raporlama/yorumlama)
class DoctorOrdersTab extends StatefulWidget {
  final String patientName;

  const DoctorOrdersTab({
    super.key,
    required this.patientName,
  });

  @override
  State<DoctorOrdersTab> createState() => _DoctorOrdersTabState();
}

class _DoctorOrdersTabState extends State<DoctorOrdersTab> {
  final Set<String> _selectedTests = {
    'Hemogram (Tam Kan Sayımı)',
    'Transtorasik EKO',
  };

  final TextEditingController _commentController = TextEditingController(
    text:
        'Hasta göğüs ağrısı ve dispne ile başvurdu. Akut koroner sendrom ekarte edilmek üzere EKG ve troponin takibi yapıldı. Kontrol tetkikleri planlandı.',
  );

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // Hasta Bilgi Rozeti
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.biotech_rounded,
                  color: AppColors.secondary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Aktif Tetkik İstem Masası: ${widget.patientName}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 1. Yeni Tetkik İstemi Oluşturma
        const Text(
          'Yeni Tetkik & Görüntüleme İstemi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        _buildTestCheckTile('Hemogram (Tam Kan Sayımı)', 'Laboratuvar'),
        _buildTestCheckTile('Biyokimya & Elektrolit Paneli', 'Laboratuvar'),
        _buildTestCheckTile('Kardiyak Troponin I & T', 'Acil Biyokimya'),
        _buildTestCheckTile('Akciğer PA Grafisi (Röntgen)', 'Radyoloji'),
        _buildTestCheckTile('Transtorasik EKO', 'Kardiyak Görüntüleme'),
        _buildTestCheckTile('Koroner BT Anjiyografi', 'İleri Radyoloji'),

        const SizedBox(height: 16),

        // 2. Hekim Klinik Yorumu ve Raporlama Alanı
        const Text(
          'Hekim Açık Klinik Rapor Yorumu',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        TextField(
          controller: _commentController,
          maxLines: 4,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Klinik kanaat, istem gerekçesi ve tanı yorumunu yazınız...',
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // İstemleri Laboratuvar / Radyolojiye İlet Butonu
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.send_rounded, size: 18),
            label: Text('${_selectedTests.length} İstem ve Raporu Onayla'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tetkik istemleri ilgili laboratuvar ve radyoloji birimlerine iletildi.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTestCheckTile(String name, String department) {
    final isChecked = _selectedTests.contains(name);

    return InkWell(
      onTap: () {
        setState(() {
          if (isChecked) {
            _selectedTests.remove(name);
          } else {
            _selectedTests.add(name);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isChecked
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isChecked ? AppColors.primaryLight : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              color: isChecked ? AppColors.primaryLight : AppColors.textMuted,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: isChecked ? AppColors.textPrimary : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                department,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
