import 'package:flutter/material.dart';

/// Randevu akışı için Poliklinik/Bölüm modeli
@immutable
class DepartmentModel {
  final String id;
  final String name;
  final IconData icon;
  final List<String> hospitalIds;

  const DepartmentModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.hospitalIds,
  });

  static List<DepartmentModel> mockList() {
    return const [
      DepartmentModel(
        id: 'dept_cardio',
        name: 'Kardiyoloji (Kalp ve Damar)',
        icon: Icons.favorite_rounded,
        hospitalIds: ['hosp_01', 'hosp_02', 'hosp_03', 'hosp_04', 'hosp_05'],
      ),
      DepartmentModel(
        id: 'dept_internal',
        name: 'İç Hastalıkları (Dahiliye)',
        icon: Icons.medical_services_rounded,
        hospitalIds: ['hosp_01', 'hosp_02', 'hosp_03', 'hosp_04', 'hosp_05'],
      ),
      DepartmentModel(
        id: 'dept_eye',
        name: 'Göz Hastalıkları',
        icon: Icons.remove_red_eye_rounded,
        hospitalIds: ['hosp_01', 'hosp_02', 'hosp_03'],
      ),
      DepartmentModel(
        id: 'dept_ortho',
        name: 'Ortopedi ve Travmatoloji',
        icon: Icons.accessibility_new_rounded,
        hospitalIds: ['hosp_01', 'hosp_02', 'hosp_04', 'hosp_05'],
      ),
      DepartmentModel(
        id: 'dept_neuro',
        name: 'Nöroloji (Beyin ve Sinir)',
        icon: Icons.psychology_rounded,
        hospitalIds: ['hosp_01', 'hosp_02', 'hosp_03', 'hosp_05'],
      ),
      DepartmentModel(
        id: 'dept_ent',
        name: 'Kulak Burun Boğaz (KBB)',
        icon: Icons.hearing_rounded,
        hospitalIds: ['hosp_01', 'hosp_02', 'hosp_03', 'hosp_04'],
      ),
      DepartmentModel(
        id: 'dept_chest',
        name: 'Göğüs Hastalıkları',
        icon: Icons.air_rounded,
        hospitalIds: ['hosp_01', 'hosp_02', 'hosp_04', 'hosp_05'],
      ),
      DepartmentModel(
        id: 'dept_derma',
        name: 'Dermatoloji (Cildiye)',
        icon: Icons.spa_rounded,
        hospitalIds: ['hosp_01', 'hosp_03', 'hosp_04'],
      ),
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepartmentModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
