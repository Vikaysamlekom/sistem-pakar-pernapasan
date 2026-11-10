class ExpertSystemEngine {
  // Daftar 19 Gejala Berdasarkan Tabel 2 Jurnal[cite: 4]
  static final Map<String, String> symptoms = {
    'G01': 'Sesak nafas',
    'G02': 'Batuk, terutama pada malam/dini hari',
    'G03': 'Mengi (bunyi siulan saat bernafas)',
    'G04': 'Dada terasa sesak',
    'G05': 'Nafas pendek atau cepat',
    'G06': 'Batuk kronis dengan atau tanpa dahak',
    'G07': 'Produksi lender berlebihan',
    'G08': 'Kelelahan',
    'G09': 'Infeksi saluran pernafasan yang sering',
    'G10': 'Batuk kering yang persisten',
    'G11': 'Penurunan berat badan yang tak terduga',
    'G12': 'Nyeri otot dan sendi',
    'G13': 'Jari atau kuku yang membulat atau membesar',
    'G14': 'Batuk Kronis dengan produksi dahak yang banyak',
    'G15': 'Nyeri dada',
    'G16': 'Hemoptisis (batuk darah)',
    'G17': 'Demam',
    'G18': 'Pembengkakan kelenjar getah bening',
    'G19': 'Ruam kulit/luka pada kulit',
  };

  // Evaluasi Rule Forward Chaining Berdasarkan Input Gejala Pengguna
  static Map<String, dynamic> evaluateDiagnosis(List<String> userSymptoms) {
    // RULE 1: P01 (Asma) -> G01, G02, G03, G04, G05[cite: 3]
    if (_containsAll(userSymptoms, ['G01', 'G02', 'G03', 'G04', 'G05'])) {
      return {
        'code': 'P01',
        'name': 'Asma',
        'description': 'Penyakit saluran pernapasan kronis yang ditandai dengan peradangan dan penyempitan saluran napas.',
        'solution': 'Lakukan pemeriksaan rutin dengan dokter spesialis paru atau poli asma.'
      };
    }
    // RULE 2: P02 (PPOK) -> G01, G06, G07, G03, G08, G09[cite: 3]
    else if (_containsAll(userSymptoms, ['G01', 'G06', 'G07', 'G03', 'G08', 'G09'])) {
      return {
        'code': 'P02',
        'name': 'Penyakit Paru Obstruktif Kronis (PPOK)',
        'description': 'Kondisi inflamasi paru kronis yang menghalangi aliran udara dari paru-paru.',
        'solution': 'Segera konsultasikan ke dokter paru, hindari paparan asap rokok, debu, dan polusi.'
      };
    }
    // RULE 3: P03 (FPI) -> G01, G10, G08, G11, G12, G13[cite: 3]
    else if (_containsAll(userSymptoms, ['G01', 'G10', 'G08', 'G11', 'G12', 'G13'])) {
      return {
        'code': 'P03',
        'name': 'Fibrosis Paru Idiopatik (FPI)',
        'description': 'Penyakit di mana jaringan paru-paru mengalami penebalan, pengerasan, atau jaringan parut.',
        'solution': 'Memerlukan evaluasi klinis mendalam, tes fungsi paru, dan penanganan oleh dokter ahli.'
      };
    }
    // RULE 4: P04 (Bronkiektasis) -> G14, G09, G01, G15, G03, G08, G16[cite: 3]
    else if (_containsAll(userSymptoms, ['G14', 'G09', 'G01', 'G15', 'G03', 'G08', 'G16'])) {
      return {
        'code': 'P04',
        'name': 'Bronkiektasis',
        'description': 'Kondisi kerusakan pada saluran bronkus di paru-paru yang membuat saluran melebar dan berlendir.',
        'solution': 'Pembersihan saluran napas, rehabilitasi paru, dan pemberian antibiotik atas resep dokter.'
      };
    }
    // RULE 5: P05 (Sarkoidosis) -> G01, G10, G15, G08, G17, G11, G18, G19[cite: 3]
    else if (_containsAll(userSymptoms, ['G01', 'G10', 'G15', 'G08', 'G17', 'G11', 'G18', 'G19'])) {
      return {
        'code': 'P05',
        'name': 'Sarkoidosis',
        'description': 'Pertumbuhan kumpulan sel peradangan kecil (granuloma) di berbagai organ tubuh, terutama paru-paru.',
        'solution': 'Pengawasan medis berkala, pemantauan fungsi organ, dan penanganan inflamasi.'
      };
    }

    // Jika gejala tidak cocok secara spesifik dengan rule di atas
    return {
      'code': 'P_UNKNOWN',
      'name': 'Tidak Teridentifikasi / Gejala Belum Spesifik',
      'description': 'Kombinasi gejala yang Anda pilih belum memenuhi pola pasti penyakit pernapasan kronis dalam basis pengetahuan sistem.',
      'solution': 'Disarankan untuk tetap melakukan pemeriksaan mandiri lanjutan atau berkonsultasi langsung ke dokter umum/spesialis.'
    };
  }

  static bool _containsAll(List<String> source, List<String> target) {
    return target.every((element) => source.contains(element));
  }
}