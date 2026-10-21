import 'package:flutter/material.dart';
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
                  patientName: state.nextPatientName,
                  patientTc: state.nextPatientTc,
                ),

                // Sekme 2: İstem Merkezi
                DoctorOrdersTab(patientName: state.nextPatientName),

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
            onStartExam: _controller.startCurrentExamination,
            onFinishExam: _controller.finishCurrentExamination,
          ),
          const SizedBox(height: 18),

          // 4. Günlük Randevu Akışı Özeti
          const SizedBox(
            height: 380,
            child: DoctorAppointmentsTab(),
          ),
        ],
      ),
    );
  }
}
