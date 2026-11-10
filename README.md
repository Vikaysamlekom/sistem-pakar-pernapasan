# 🫁 Sistem Pakar Diagnosis Awal Penyakit Pernapasan Kronis

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![AI - Forward Chaining](https://img.shields.io/badge/AI-Forward%20Chaining-FF6F00?style=for-the-badge&logo=google-analytics&logoColor=white)](#metode-inferensi-forward-chaining)
[![Live Demo](https://img.shields.io/badge/Live%20Demo-GitHub%20Pages-22C55E?style=for-the-badge&logo=github&logoColor=white)](https://ranggawaridat.github.io/projects/sistem-pakar-pernapasan)

Aplikasi sistem pakar berbasis mobile dan web yang dirancang untuk mendeteksi dini penyakit pernapasan kronis pada manusia menggunakan metode inferensi **Forward Chaining**. Proyek ini dikembangkan sebagai tugas akhir mata kuliah **Artificial Intelligence (Kecerdasan Buatan)** di Program Studi Teknik Informatika, Universitas Pembangunan Nasional "Veteran" Jawa Timur.

---

## 📌 Gambaran Umum & Latar Belakang

Penyakit pernapasan kronis seperti Asma, Penyakit Paru Obstruktif Kronis (PPOK), Fibrosis Paru Idiopatik (FPI), Bronkiektasis, dan Sarkoidosis merupakan penyebab utama morbiditas dan mortalitas global. Keterbatasan akses langsung ke fasilitas medis dan tenaga ahli spesialis paru sering kali memperlambat penanganan awal.

Aplikasi ini mengadaptasi basis pengetahuan (*knowledge base*) dan aturan penalaran dari penelitian ilmiah terkini untuk memberikan diagnosis sementara yang cepat, konsisten, dan akurat berdasarkan input gejala yang dirasakan oleh pengguna.

---

## 📄 Referensi Jurnal Acuan

Pengembangan logika *rule-based* dan data gejala pada sistem pakar ini sepenuhnya mengacu pada jurnal nasional terakreditasi berikut:

* **Judul Jurnal**: *Penerapan Sistem Pakar untuk Diagnosis Awal Penyakit Pernapasan Kronis pada Manusia*
* **Penulis**: Nur Septia Fajrina, Muhammad Akbar Nurdianto, Muhammad Sulthan Zahran, Anggraini Puspita Sari
* **Afiliasi**: Program Studi Informatika, Fakultas Ilmu Komputer, Universitas Pembangunan Nasional "Veteran" Jawa Timur
* **Publikasi**: *JAMASTIKA*, Vol. 3 No. 2, Oktober 2024 (ISSN / e-ISSN Terakreditasi)

---

## 🧠 Metode Inferensi: Forward Chaining

Sistem pakar ini menggunakan pendekatan **Forward Chaining** (penalaran maju). Proses inferensi dimulai dari pengumpulan fakta-fakta berupa gejala ($G_{01} - G_{19}$) yang diderita pasien melalui kuesioner interaktif *Ya/Tidak*, kemudian mencocokkannya dengan aturan (*rules*) yang telah ditetapkan di basis pengetahuan hingga menghasilkan kesimpulan diagnosis penyakit ($P_{01} - P_{05}$).

```text
  [ Input Gejala Pasien (Fakta) ]
                │
                ▼
   [ Mesin Inferensi (Forward Chaining) ]
                │
                ▼
  [ Pencocokan Aturan (Rule Base P01 - P05) ]
                │
                ▼
    [ Kesimpulan Diagnosis & Solusi ]

```

### 📋 Data Penyakit & Kode ($P_{xx}$)

| Kode | Nama Penyakit |
| --- | --- |
| **P01** | Asma |
| **P02** | Penyakit Paru Obstruktif Kronis (PPOK) |
| **P03** | Fibrosis Paru Idiopatik (FPI) |
| **P04** | Bronkiektasis |
| **P05** | Sarkoidosis |

### 🔍 Data Gejala & Kode ($G_{xx}$)

| Kode | Jenis Gejala | Kode | Jenis Gejala |
| --- | --- | --- | --- |
| **G01** | Sesak nafas | **G11** | Penurunan berat badan tak terduga |
| **G02** | Batuk (terutama malam/dini hari) | **G12** | Nyeri otot dan sendi |
| **G03** | Mengi (bunyi siulan saat bernafas) | **G13** | Jari/kuku membulat atau membesar (*clubbing*) |
| **G04** | Dada terasa sesak | **G14** | Batuk kronis dengan banyak dahak |
| **G05** | Nafas pendek atau cepat | **G15** | Nyeri dada |
| **G06** | Batuk kronis dengan/tanpa dahak | **G16** | Hemoptisis (batuk darah) |
| **G07** | Produksi lendir berlebihan | **G17** | Demam |
| **G08** | Kelelahan (*fatigue*) | **G18** | Pembengkakan kelenjar getah bening |
| **G09** | Infeksi saluran pernapasan sering | **G19** | Ruam atau luka pada kulit |
| **G10** | Batuk kering persisten |  |  |

### ⚡ Aturan Inferensi (Knowledge Rules)

* **Rule 1 (P01 - Asma)**: `IF G01 AND G02 AND G03 AND G04 AND G05 THEN P01`
* **Rule 2 (P02 - PPOK)**: `IF G01 AND G06 AND G07 AND G03 AND G08 AND G09 THEN P02`
* **Rule 3 (P03 - FPI)**: `IF G01 AND G10 AND G08 AND G11 AND G12 AND G13 THEN P03`
* **Rule 4 (P04 - Bronkiektasis)**: `IF G14 AND G09 AND G01 AND G15 AND G03 AND G08 AND G16 THEN P04`
* **Rule 5 (P05 - Sarkoidosis)**: `IF G01 AND G10 AND G15 AND G08 AND G17 AND G11 AND G18 AND G19 THEN P05`

---

## ✨ Fitur Utama Aplikasi

1. **Diagnosis Interaktif**: Kuesioner pertanyaan gejala yang mudah dipahami dengan respon *Ya / Tidak*.
2. **Evaluasi Real-time**: Mesin inferensi mengevaluasi pencocokan pola gejala secara instant di sisi klien.
3. **Hasil & Solusi Penanganan**: Menampilkan rincian hasil penyakit beserta rekomendasi atau tindakan medis awal.
4. **Respon Cepat & Ringan**: Tidak memerlukan autentikasi/login sehingga pengguna dapat langsung melakukan cek kesehatan.
5. **Cross-Platform**: Kompatibel untuk dijalankan di Android, iOS, maupun Web (PWAs/Web Apps).

---

## 🛠️ Teknologi & Arsitektur Kode

* **Framework**: [Flutter](https://flutter.dev) (UI Toolkit)
* **Language**: [Dart](https://dart.dev)
* **Architecture Pattern**: State Management Sederhana & Clean Modular Architecture

```text
lib/
├── data/
│   └── expert_rules.dart      # Basis pengetahuan & Logika Forward Chaining
├── screens/
│   ├── diagnosis_screen.dart  # Antarmuka Kuesioner & Pertanyaan Gejala
│   └── result_screen.dart     # Antarmuka Hasil Diagnosis & Solusi Medis
└── main.dart                  # Entry point aplikasi Flutter

```

---

## 🚀 Cara Menjalankan Proyek Secara Lokal

### Prasyarat

* Flutter
* Dart 
* IDE: VS Code / Android Studio

### Langkah Instalasi

1. **Clone Repositori Ini**:
```bash
git clone [https://github.com/ranggawaridat/sistem-pakar-pernapasan.git](https://github.com/ranggawaridat/sistem-pakar-pernapasan.git)
cd sistem-pakar-pernapasan

```


2. **Dapatkan Dependencies**:
```bash
flutter pub get

```


3. **Jalankan Aplikasi**:
* Untuk Web:
```bash
flutter run -d chrome

```


* Untuk Device Android / Emulator:
```bash
flutter run

```





---

## 🌐 Live Web Demo

Aplikasi ini dapat diakses secara langsung melalui peramban (browser) tanpa instalasi pada tautan berikut:

👉 **[https://ranggawaridat.github.io/projects/sistem-pakar-pernapasan](https://ranggawaridat.github.io/projects/sistem-pakar-pernapasan)**

---
