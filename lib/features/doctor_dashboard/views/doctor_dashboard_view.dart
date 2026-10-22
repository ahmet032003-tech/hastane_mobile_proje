import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/doctor_dashboard_controller.dart';
import '../models/doctor_dashboard_state.dart';
import '../widgets/doctor_bottom_nav_bar.dart';
import '../widgets/doctor_dashboard_header.dart';
import '../widgets/doctor_operation_metrics.dart';
import '../widgets/next_patient_card.dart';
import '../widgets/tabs/doctor_appointments_tab.dart';
import '../widgets/tabs/doctor_e_prescription_tab.dart';
import '../widgets/tabs/doctor_orders_tab.dart';
import '../widgets/tabs/doctor_profile_tab.dart';

/// Doktor Dashboard & Poliklinik Masası Ana Ekranı (features/doctor_dashboard)
class DoctorDashboardView extends StatefulWidget {
  final DoctorDashboardController? controller;

  const DoctorDashboardView({
    super.key,
    this.controller,
  });

  @override
  State<DoctorDashboardView> createState() => _DoctorDashboardViewState();
}

class _DoctorDashboardViewState extends State<DoctorDashboardView> {
  late final DoctorDashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DoctorDashboardController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleFinishExamination() {
    final wasLastPatient = _controller.value.upcomingQueue.isEmpty;
    _controller.finishCurrentExamination();

    if (wasLastPatient || !_controller.value.hasNextPatient) {
      _showAllExaminationsCompletedNotification();
    }
  }

  void _showAllExaminationsCompletedNotification() {
    if (!mounted) return;

    // Toast/SnackBar bildirimi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Tüm hastalar muayene edildi. Bekleyen hasta kalmadı!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );

    // Bilgilendirme Diyaloğu
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.task_alt_rounded,
            color: AppColors.success,
            size: 40,
          ),
        ),
        title: const Text(
          'Tüm Muayeneler Tamamlandı',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Sayın hekimimiz, bugünkü poliklinik randevu listesindeki tüm hastaların muayenesi başarıyla tamamlandı.\n\nBekleyen başka hasta kalmamıştır. Tebrik eder, iyi dinlenmeler dileriz.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.45,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Anladım',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DoctorDashboardState>(
      valueListenable: _controller,
      builder: (context, state, _) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: state.selectedMenuIndex,
              children: [
                // Sekme 0: Poliklinik Masası & Dashboard
                _buildDeskDashboard(state),

                // Sekme 1: E-Reçete Masası
                DoctorEPrescriptionTab(
                  patientName: state.hasNextPatient
                      ? state.nextPatientName
                      : 'Kayıtlı / Aktif Hasta Yok',
                  patientTc: state.hasNextPatient ? state.nextPatientTc : '-',
                  availablePatients: state.appointments,
                  doctorName: state.fullDoctorName,
                  clinicName: state.clinicName,
                ),

                // Sekme 2: İstem Merkezi
                DoctorOrdersTab(
                  patientName: state.hasNextPatient
                      ? state.nextPatientName
                      : 'Kayıtlı / Aktif Hasta Yok',
                ),

                // Sekme 3: Doktor Profili & Çalışma Takvimi
                DoctorProfileTab(
                  doctorName: state.fullDoctorName,
                  clinicName: state.clinicName,
                ),
              ],
            ),
          ),
          bottomNavigationBar: DoctorBottomNavBar(
            currentIndex: state.selectedMenuIndex,
            onTabSelected: _controller.setMenuIndex,
          ),
        );
      },
    );
  }

  Widget _buildDeskDashboard(DoctorDashboardState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Üst Bölüm: Hekim görseli, unvan, ad-soyad, poliklinik adı ve Açık/Mola anahtarı
          DoctorDashboardHeader(
            fullDoctorName: state.fullDoctorName,
            clinicName: state.clinicName,
            isExamOpen: state.isExamOpen,
            onExamStatusChanged: _controller.toggleExamStatus,
          ),
          const SizedBox(height: 18),

          // 2. Operasyon Metrikleri: Günlük toplam randevu, tamamlanan, bekleyen
          DoctorOperationMetrics(
            totalAppointments: state.totalAppointments,
            completedExaminations: state.completedExaminations,
            waitingPatients: state.waitingPatients,
          ),
          const SizedBox(height: 18),

          // 3. Sıradaki Hasta: Kapıdaki hastanın adı, saati, şikayeti ve "Muayeneyi Başlat" butonu
          NextPatientCard(
            patientName: state.nextPatientName,
            appointmentTime: state.nextPatientTime,
            complaint: state.nextPatientComplaint,
            queueNumber: state.nextPatientQueueNumber,
            tc: state.nextPatientTc,
            isExamInProgress: state.isExamInProgress,
            hasNextPatient: state.hasNextPatient,
            onStartExam: _controller.startCurrentExamination,
            onFinishExam: _handleFinishExamination,
            onResetQueue: _controller.resetQueue,
          ),
          const SizedBox(height: 18),

          // 4. Günlük Randevu Akışı Özeti
          SizedBox(
            height: 380,
            child: DoctorAppointmentsTab(
              appointments: state.appointments,
            ),
          ),
        ],
      ),
    );
  }
}
