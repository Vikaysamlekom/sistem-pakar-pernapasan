import 'package:flutter/material.dart';
import 'screens/diagnosis_screen.dart';

void main() {
  runApp(const ExpertSystemApp());
}

class ExpertSystemApp extends StatelessWidget {
  const ExpertSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Pakar Pernapasan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
      home: const DiagnosisScreen(),
    );
  }
}