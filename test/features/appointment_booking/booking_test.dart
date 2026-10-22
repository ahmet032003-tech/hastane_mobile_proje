import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/core/theme/app_theme.dart';
import 'package:hastane_otomasyon/features/appointment_booking/controllers/booking_controller.dart';
import 'package:hastane_otomasyon/features/appointment_booking/models/department_model.dart';
import 'package:hastane_otomasyon/features/appointment_booking/models/doctor_model.dart';
import 'package:hastane_otomasyon/features/appointment_booking/models/hospital_model.dart';
import 'package:hastane_otomasyon/features/appointment_booking/models/time_slot_model.dart';
import 'package:hastane_otomasyon/features/appointment_booking/views/appointment_booking_view.dart';
import 'package:hastane_otomasyon/features/appointment_booking/widgets/date_time_selection_step.dart';
import 'package:hastane_otomasyon/features/appointment_booking/services/appointment_repository.dart';
import 'package:hastane_otomasyon/features/doctor_dashboard/controllers/doctor_dashboard_controller.dart';

void main() {
  group('BookingController & BookingState Unit Tests', () {
    late BookingController controller;

    setUp(() {
      controller = BookingController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state requires hospital selection to proceed', () {
      expect(controller.value.currentStep, 0);
      expect(controller.value.selectedHospital, isNull);
      expect(controller.value.canProceed, isFalse);

      final nextResult = controller.nextStep();
      expect(nextResult, isFalse);
      expect(controller.value.errorMessage, isNotNull);
    });

    test('Full 4-step selection flow and confirmation', () async {
      final hospital = HospitalModel.mockList().first;
      final department = DepartmentModel.mockList().first;
      final doctor = DoctorModel.mockList().first;
      final date = DateTime.now();
      final availableSlot = TimeSlotModel.mockMorningSlots().first; // 09:00, not booked

      // 1. Adım: Hastane Seçimi
      controller.selectHospital(hospital);
      expect(controller.value.selectedHospital, hospital);
      expect(controller.value.canProceed, isTrue);
      expect(controller.nextStep(), isTrue);
      expect(controller.value.currentStep, 1);

      // 2. Adım: Bölüm Seçimi
      controller.selectDepartment(department);
      expect(controller.value.selectedDepartment, department);
      expect(controller.value.canProceed, isTrue);
      expect(controller.nextStep(), isTrue);
      expect(controller.value.currentStep, 2);

      // 3. Adım: Doktor Seçimi
      controller.selectDoctor(doctor);
      expect(controller.value.selectedDoctor, doctor);
      expect(controller.value.canProceed, isTrue);
      expect(controller.nextStep(), isTrue);
      expect(controller.value.currentStep, 3);

      // 4. Adım: Tarih & Saat Seçimi
      controller.selectDate(date);
      expect(controller.value.canProceed, isFalse); // Slot henüz seçilmedi

      // Dolu slot seçilemez testi
      const bookedSlot =
          TimeSlotModel(time: '09:30', isMorning: true, isBooked: true);
      controller.selectTimeSlot(bookedSlot);
      expect(controller.value.selectedTimeSlot, isNull);
      expect(controller.value.canProceed, isFalse);

      // Müsait slot seçimi
      controller.selectTimeSlot(availableSlot);
      expect(controller.value.selectedTimeSlot, availableSlot);
      expect(controller.value.canProceed, isTrue);
      expect(controller.value.isReadyForConfirmation, isTrue);

      // Onaylama işlemi
      final confirmed = await controller.confirmAppointment();
      expect(confirmed, isTrue);
      expect(controller.value.isConfirmed, isTrue);
      expect(controller.value.confirmedAppointmentId, isNotNull);
      expect(controller.value.confirmedAppointmentId, startsWith('RND-'));
    });

    test('confirmAppointment adds appointment to DoctorDashboardController in real time', () async {
      AppointmentRepository.instance.reset();
      final doctorController = DoctorDashboardController();
      final initialAppointmentsCount = doctorController.value.appointments.length;
      final initialTotal = doctorController.value.totalAppointments;
      final initialWaiting = doctorController.value.waitingPatients;

      final hospital = HospitalModel.mockList().first;
      final department = DepartmentModel.mockList().first;
      final doctor = DoctorModel.mockList().first;
      final date = DateTime.now();
      final slot = TimeSlotModel.mockMorningSlots().first;

      controller.selectHospital(hospital);
      controller.nextStep();
      controller.selectDepartment(department);
      controller.nextStep();
      controller.selectDoctor(doctor);
      controller.nextStep();
      controller.selectDate(date);
      controller.selectTimeSlot(slot);

      final success = await controller.confirmAppointment(
        patientName: 'Ayşe Yılmaz',
        patientTc: '12345678901',
      );
      expect(success, isTrue);

      // Doktor ekranına randevu anında yansımış olmalı
      expect(doctorController.value.appointments.length, initialAppointmentsCount + 1);
      expect(doctorController.value.totalAppointments, initialTotal + 1);
      expect(doctorController.value.waitingPatients, initialWaiting + 1);

      final lastAppt = doctorController.value.appointments.last;
      expect(lastAppt.patientName, 'Ayşe Yılmaz');
      expect(lastAppt.tc, '12345678901');
      expect(lastAppt.status, 'Kapıda Bekliyor');

      doctorController.dispose();
    });

    test('previousStep goes back correctly', () {
      final hospital = HospitalModel.mockList().first;
      controller.selectHospital(hospital);
      controller.nextStep();
      expect(controller.value.currentStep, 1);

      controller.previousStep();
      expect(controller.value.currentStep, 0);
    });
  });

  group('AppointmentBookingView Widget Smoke Test', () {
    testWidgets('Renders 4 steps indicator and hospital step',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const AppointmentBookingView(),
        ),
      );

      // Başlık ve İlerleme göstergeleri
      expect(find.text('Randevu Alma Sihirbazı'), findsOneWidget);
      expect(find.text('Hastane'), findsOneWidget);
      expect(find.text('Bölüm'), findsOneWidget);
      expect(find.text('Doktor'), findsOneWidget);
      expect(find.text('Tarih/Saat'), findsOneWidget);

      // 1. Adım listesi
      expect(find.text('En Yakın Sağlık Kuruluşları'), findsOneWidget);
      expect(find.text('MedAuto Kadıköy Şehir Hastanesi'), findsOneWidget);
      expect(find.text('Devam Et'), findsOneWidget);
    });

    testWidgets(
        'DateTimeSelectionStep renders dates and time slots without overflow',
        (WidgetTester tester) async {
      final doctor = DoctorModel.mockList().first;
      DateTime? selectedDate = DateTime.now();
      TimeSlotModel? selectedSlot;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: DateTimeSelectionStep(
                doctor: doctor,
                selectedDate: selectedDate,
                selectedTimeSlot: selectedSlot,
                onDateSelected: (date) => selectedDate = date,
                onTimeSlotSelected: (slot) => selectedSlot = slot,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Randevu Tarihi Seçin'), findsOneWidget);
      expect(find.text('Bugün'), findsOneWidget);
      expect(find.text('Sabah Slotları'), findsOneWidget);
      expect(find.text('Öğleden Sonra Slotları'), findsOneWidget);
    });
  });
}
