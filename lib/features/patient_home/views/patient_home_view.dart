import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../patient_profile/views/patient_profile_view.dart';
import '../controllers/patient_home_controller.dart';
import '../models/patient_home_state.dart';
import '../models/patient_model.dart';
import '../widgets/patient_active_diseases.dart';
import '../widgets/patient_bottom_navigation_bar.dart';
import '../widgets/patient_health_metrics.dart';
import '../widgets/patient_home_header.dart';
import '../../appointment_booking/views/appointment_booking_view.dart';
import '../../medications/views/medications_view.dart';
import '../../medical_tests/views/medical_tests_view.dart';

/// Hasta Ana Sayfası ve Alt Sekmeler Ana Ekranı (features/patient_home)
class PatientHomeView extends StatefulWidget {
  final PatientModel? initialPatient;

  const PatientHomeView({
    super.key,
    this.initialPatient,
  });

  @override
  State<PatientHomeView> createState() => _PatientHomeViewState();
}

class _PatientHomeViewState extends State<PatientHomeView> {
  late final PatientHomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PatientHomeController(initialPatient: widget.initialPatient);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PatientHomeState>(
      valueListenable: _controller,
      builder: (context, state, _) {
        final patient = state.patient;

        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: state.selectedTabIndex,
              children: [
                // Sekme 0: Randevu Al / Hasta Ana Paneli
                _buildHomeDashboard(patient, state),

                // Sekme 1: İlaçlar ve Reçeteler
                const MedicationsView(),

                // Sekme 2: Radyoloji ve Tahliller
                const MedicalTestsView(),

                // Sekme 3: Hasta Profil Sayfası
                PatientProfileView(
                  patient: patient,
                  onPatientUpdated: _controller.updatePatient,
                ),
              ],
            ),
          ),
          bottomNavigationBar: PatientBottomNavigationBar(
            currentIndex: state.selectedTabIndex,
            onTabSelected: _controller.setTabIndex,
          ),
        );
      },
    );
  }

  /// Sekme 0: Hasta Ana Sayfası İçeriği
  Widget _buildHomeDashboard(PatientModel patient, PatientHomeState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Üst Bölüm: Hasta profil resmi, ad-soyad, son ziyaret tarihi, son hekim ve branş bilgisi
          PatientHomeHeader(
            patient: patient,
            onProfileTap: () => _controller.setTabIndex(3),
          ),
          const SizedBox(height: 20),

          // 2. Kişisel Sağlık Verileri: Boy, kilo, hesaplanan BMI ve aktif kullanılan ilaç sayısı
          PatientHealthMetrics(
            patient: patient,
            onPatientUpdated: _controller.updatePatient,
          ),
          const SizedBox(height: 20),

          // 3. Aktif Hastalıklar: Kronik/aktif tanılar yatay chip etiketleri
          PatientActiveDiseases(
            diseases: patient.activeDiseases,
            selectedDisease: state.selectedDiseaseFilter,
            onDiseaseSelected: _controller.toggleDiseaseFilter,
          ),
          const SizedBox(height: 20),

          // 4. Randevu Al Hızlı Aksiyon Kartı (4 Adımlı Seçim Akışı Başlatıcısı)
          _buildQuickAppointmentCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Hızlı Randevu Alma Kartı (features/appointment_booking bağlantısı)
  Widget _buildQuickAppointmentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F2B48),
            Color(0xFF162032),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primaryLight,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yeni Randevu Al',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '4 adımlı sıralı seçim sihirbazı',
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            '1. Hastane Seçimi  ➔  2. Bölüm Seçimi  ➔  3. Doktor Seçimi  ➔  4. Tarih & Saat',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Randevu Sihirbazını Başlat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AppointmentBookingView(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
