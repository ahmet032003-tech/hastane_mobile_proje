import 'package:flutter_test/flutter_test.dart';
import 'package:hastane_otomasyon/features/doctor_dashboard/controllers/doctor_dashboard_controller.dart';

void main() {
  group('DoctorDashboardController Tests', () {
    late DoctorDashboardController controller;

    setUp(() {
      controller = DoctorDashboardController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial state values are correct', () {
      expect(controller.value.doctorName, 'Emre Çetin');
      expect(controller.value.doctorTitle, 'Doç. Dr.');
      expect(controller.value.clinicName, 'Kardiyoloji Polikliniği 1');
      expect(controller.value.isExamOpen, isTrue);
      expect(controller.value.totalAppointments, 24);
      expect(controller.value.completedExaminations, 15);
      expect(controller.value.waitingPatients, 9);
      expect(controller.value.isExamInProgress, isFalse);
      expect(controller.value.selectedMenuIndex, 0);
    });

    test('toggleExamStatus updates isExamOpen correctly', () {
      controller.toggleExamStatus(false);
      expect(controller.value.isExamOpen, isFalse);

      controller.toggleExamStatus(true);
      expect(controller.value.isExamOpen, isTrue);
    });

    test('startCurrentExamination sets isExamInProgress to true', () {
      controller.startCurrentExamination();
      expect(controller.value.isExamInProgress, isTrue);
    });

    test('finishCurrentExamination increments completed and decrements waiting', () {
      final initialCompleted = controller.value.completedExaminations;
      final initialWaiting = controller.value.waitingPatients;
      final initialQueue = controller.value.nextPatientQueueNumber;

      controller.startCurrentExamination();
      expect(controller.value.isExamInProgress, isTrue);

      controller.finishCurrentExamination();

      expect(controller.value.isExamInProgress, isFalse);
      expect(controller.value.completedExaminations, initialCompleted + 1);
      expect(controller.value.waitingPatients, initialWaiting - 1);
      expect(controller.value.nextPatientQueueNumber, initialQueue + 1);
      expect(controller.value.nextPatientName, isNotEmpty);
    });

    test('setMenuIndex switches between dashboard tabs', () {
      controller.setMenuIndex(1);
      expect(controller.value.selectedMenuIndex, 1);

      controller.setMenuIndex(2);
      expect(controller.value.selectedMenuIndex, 2);

      controller.setMenuIndex(3);
      expect(controller.value.selectedMenuIndex, 3);

      // Invalid indexes should be ignored
      controller.setMenuIndex(5);
      expect(controller.value.selectedMenuIndex, 3);
      controller.setMenuIndex(-1);
      expect(controller.value.selectedMenuIndex, 3);
    });
  });
}
