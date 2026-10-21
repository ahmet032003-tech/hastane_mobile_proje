import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/medical_tests_controller.dart';
import '../models/medical_test_model.dart';
import '../models/medical_tests_state.dart';
import '../widgets/medical_test_card.dart';
import '../widgets/medical_test_detail_modal.dart';
import '../widgets/medical_test_filters_bar.dart';

/// Radyoloji ve Tahliller Ana Ekranı (features/medical_tests)
class MedicalTestsView extends StatefulWidget {
  final MedicalTestsController? controller;

  const MedicalTestsView({
    super.key,
    this.controller,
  });

  @override
  State<MedicalTestsView> createState() => _MedicalTestsViewState();
}

class _MedicalTestsViewState extends State<MedicalTestsView> {
  late final MedicalTestsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? MedicalTestsController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _showDetailModal(MedicalTestModel test) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MedicalTestDetailModal(test: test),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MedicalTestsState>(
      valueListenable: _controller,
      builder: (context, state, _) {
        final list = state.filteredTests;

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
                      'Radyoloji & Tahliller',
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
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.secondary.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        '${list.length} Tetkik',
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Filtre ve Arama Barı
                MedicalTestFiltersBar(
                  searchQuery: state.searchQuery,
                  isSortDescending: state.isSortDescending,
                  selectedCategory: state.selectedCategory,
                  onSearchChanged: _controller.setSearchQuery,
                  onToggleSort: _controller.toggleSortOrder,
                  onCategorySelected: _controller.setCategory,
                ),
                const SizedBox(height: 16),

                // Tetkik Kartları Listesi
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
                            'Kriterlere uygun tetkik sonucu bulunamadı.',
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
                      final test = list[index];
                      return MedicalTestCard(
                        test: test,
                        onTap: () => _showDetailModal(test),
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
