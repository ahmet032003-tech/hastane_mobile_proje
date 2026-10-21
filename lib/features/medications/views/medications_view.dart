import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/medications_controller.dart';
import '../models/medication_model.dart';
import '../models/medications_state.dart';
import '../widgets/medication_card.dart';
import '../widgets/medication_detail_modal.dart';
import '../widgets/medication_filters_bar.dart';

/// İlaçlar ve Reçeteler Ekranı (features/medications)
class MedicationsView extends StatefulWidget {
  final MedicationsController? controller;

  const MedicationsView({
    super.key,
    this.controller,
  });

  @override
  State<MedicationsView> createState() => _MedicationsViewState();
}

class _MedicationsViewState extends State<MedicationsView> {
  late final MedicationsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? MedicationsController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _showDetailModal(MedicationModel medication) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => MedicationDetailModal(medication: medication),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MedicationsState>(
      valueListenable: _controller,
      builder: (context, state, _) {
        final list = state.filteredMedications;

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Başlık Satırı
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'İlaçlar ve Reçeteler',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        '${list.length} İlaç',
                        style: const TextStyle(
                          color: AppColors.primaryLight,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Filtre ve Sıralama Barı
                MedicationFiltersBar(
                  searchQuery: state.searchQuery,
                  isSortDescending: state.isSortDescending,
                  availableDiseases: state.availableDiseases,
                  selectedDiseaseFilter: state.selectedDiseaseFilter,
                  onSearchChanged: _controller.setSearchQuery,
                  onToggleSort: _controller.toggleSortOrder,
                  onDiseaseSelected: _controller.setDiseaseFilter,
                ),
                const SizedBox(height: 16),

                // İlaç Kartları Listesi
                if (list.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        children: [
                          const Icon(Icons.search_off_rounded,
                              size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'Kriterlere uygun ilaç bulunamadı.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _controller.clearAllFilters,
                            child: const Text('Filtreleri Temizle'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final med = list[index];
                      return MedicationCard(
                        medication: med,
                        onTap: () => _showDetailModal(med),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
