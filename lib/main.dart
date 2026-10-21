import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/patient_auth/views/patient_login_view.dart';

void main() {
  runApp(const MedAutoApp());
}

/// MedAuto Hastane Otomasyonu Ana Uygulaması
class MedAutoApp extends StatelessWidget {
  const MedAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acil Şifa Hastanesi',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.darkTheme,
      home: const PatientLoginView(),
    );
  }
}
