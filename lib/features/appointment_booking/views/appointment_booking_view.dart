import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/booking_controller.dart';
import '../models/booking_state.dart';
import '../models/department_model.dart';
import '../models/doctor_model.dart';
import '../models/hospital_model.dart';
import '../widgets/booking_step_indicator.dart';
import '../widgets/booking_summary_modal.dart';
import '../widgets/date_time_selection_step.dart';
import '../widgets/department_selection_step.dart';
import '../widgets/doctor_selection_step.dart';
import '../widgets/hospital_selection_step.dart';
import '../../patient_home/models/patient_model.dart';

/// 4 Adımlı Randevu Alma Sihirbazı Ekranı (features/appointment_booking)
class AppointmentBookingView extends StatefulWidget {
  final BookingController? controller;
  final PatientModel? patient;

  const AppointmentBookingView({
    super.key,
    this.controller,
    this.patient,
  });

  @override
  State<AppointmentBookingView> createState() => _AppointmentBookingViewState();
}

class _AppointmentBookingViewState extends State<AppointmentBookingView> {
  late final BookingController _controller;
  late final List<HospitalModel> _hospitals;
  late final List<DepartmentModel> _departments;
  late final List<DoctorModel> _doctors;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? BookingController();
    _hospitals = HospitalModel.mockList();
    _departments = DepartmentModel.mockList();
    _doctors = DoctorModel.mockList();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Onay özeti modalını açar
  void _openSummaryModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return ValueListenableBuilder<BookingState>(
          valueListenable: _controller,
          builder: (context, state, _) {
            return BookingSummaryModal(
              state: state,
              onCancel: () => Navigator.of(modalContext).pop(),
              onConfirm: () async {
                final success = await _controller.confirmAppointment(
                  patientName: widget.patient?.fullName,
                  patientTc: widget.patient?.tc,
                );
                if (modalContext.mounted && success) {
                  Navigator.of(modalContext).pop();
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BookingState>(
      valueListenable: _controller,
      builder: (context, state, _) {
        if (state.isConfirmed) {
          return _buildSuccessView(state);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Randevu Alma Sihirbazı'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () {
                if (state.currentStep > 0) {
                  _controller.previousStep();
                } else {
                  Navigator.of(context).maybePop();
                }
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // 4 Adımlı İlerleme Çubuğu
                BookingStepIndicator(
                  currentStep: state.currentStep,
                  onStepTapped: _controller.goToStep,
                ),

                // Hata Mesajı Varsa
                if (state.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.all(12),
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
                            state.errorMessage!,
                            style: const TextStyle(
                                color: AppColors.error, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Aktif Adım İçeriği
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: _buildCurrentStepWidget(state),
                  ),
                ),

                // Alt Aksiyon Butonları (Geri / Devam Et / Özeti Gör)
                _buildBottomActionBar(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentStepWidget(BookingState state) {
    switch (state.currentStep) {
      case 0:
        return HospitalSelectionStep(
          hospitals: _hospitals,
          selectedHospital: state.selectedHospital,
          searchQuery: state.searchQuery,
          onSearchChanged: _controller.setSearchQuery,
          onHospitalSelected: (h) {
            _controller.selectHospital(h);
            _controller.nextStep();
          },
        );
      case 1:
        return DepartmentSelectionStep(
          hospital: state.selectedHospital!,
          departments: _departments,
          selectedDepartment: state.selectedDepartment,
          searchQuery: state.searchQuery,
          onSearchChanged: _controller.setSearchQuery,
          onDepartmentSelected: (d) {
            _controller.selectDepartment(d);
            _controller.nextStep();
          },
        );
      case 2:
        return DoctorSelectionStep(
          department: state.selectedDepartment!,
          doctors: _doctors,
          selectedDoctor: state.selectedDoctor,
          searchQuery: state.searchQuery,
          onSearchChanged: _controller.setSearchQuery,
          onDoctorSelected: (doc) {
            _controller.selectDoctor(doc);
            _controller.nextStep();
          },
        );
      case 3:
        return DateTimeSelectionStep(
          doctor: state.selectedDoctor!,
          selectedDate: state.selectedDate,
          selectedTimeSlot: state.selectedTimeSlot,
          onDateSelected: _controller.selectDate,
          onTimeSlotSelected: _controller.selectTimeSlot,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomActionBar(BookingState state) {
    final isLastStep = state.currentStep == 3;
    final canProceed = state.canProceed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (state.currentStep > 0) ...[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _controller.previousStep,
              child: const Text('Geri',
                  style: TextStyle(color: AppColors.textPrimary)),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canProceed
                      ? AppColors.primary
                      : AppColors.surfaceSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: canProceed
                    ? (isLastStep ? _openSummaryModal : _controller.nextStep)
                    : null,
                child: Text(
                  isLastStep ? 'Özeti Gör ve Onayla' : 'Devam Et',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: canProceed ? Colors.white : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Randevu Başarı Onay Ekranı
  Widget _buildSuccessView(BookingState state) {
    final date = state.selectedDate!;
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.success, Color(0xFF059669)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Randevunuz Onaylandı!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Randevu detaylarınız sisteme işlenmiş ve SMS olarak gönderilmiştir.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // Takip & Barkod Kodu
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Randevu Takip No:',
                        style: TextStyle(
                            color: AppColors.textMuted, fontSize: 13),
                      ),
                      Text(
                        state.confirmedAppointmentId ?? 'RND-2026-8849',
                        style: const TextStyle(
                          color: AppColors.primaryLight,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Detay Özeti
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildSuccessInfoRow('Hastane', state.selectedHospital?.name ?? ''),
                      const Divider(color: AppColors.border, height: 16),
                      _buildSuccessInfoRow('Poliklinik', state.selectedDepartment?.name ?? ''),
                      const Divider(color: AppColors.border, height: 16),
                      _buildSuccessInfoRow('Doktor', state.selectedDoctor?.fullTitleAndName ?? ''),
                      const Divider(color: AppColors.border, height: 16),
                      _buildSuccessInfoRow(
                          'Tarih & Saat', '$formattedDate - ${state.selectedTimeSlot?.time}'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      _controller.reset();
                      Navigator.of(context).maybePop();
                    },
                    child: const Text('Ana Sayfaya Dön'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
