import 'package:flutter/material.dart';
import 'diagnosis_screen.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> diagnosisResult;

  const ResultScreen({super.key, required this.diagnosisResult});

  @override
  Widget build(BuildContext context) {
    final double confidence = (diagnosisResult['confidence'] as num?)?.toDouble() ?? 0.0;
    final List symptomList = (diagnosisResult['symptomList'] as List?) ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Diagnosis Sistem Pakar"),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hasil Analisis Berdasarkan Gejala:",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  border: Border.all(color: const Color(0xFF0D9488), width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diagnosisResult['code'],
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      diagnosisResult['name'],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      diagnosisResult['description'] ?? '',
                      style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Tingkat Keyakinan (Certainty Factor)",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: confidence,
                        minHeight: 10,
                        backgroundColor: Colors.grey[200],
                        color: const Color(0xFF0D9488),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          "${(confidence * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "Metode: Forward Chaining + Certainty Factor",
                            style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Saran / Penanganan Medis Awal:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  diagnosisResult['solution'],
                  style: const TextStyle(fontSize: 14, color: Color(0xFF374151), height: 1.4),
                ),
              ),
              if (symptomList.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  "Gejala yang Anda Alami:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final item in symptomList)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${item['code']} · ${item['name']}",
                          style: const TextStyle(fontSize: 12, color: Color(0xFF115E59)),
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DiagnosisScreen()),
                    );
                  },
                  child: const Text("Ulangi Diagnosis", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
