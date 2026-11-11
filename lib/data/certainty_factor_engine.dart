import 'expert_rules.dart';

/// Model data satu rule inferensi.
class _Rule {
  final String code;
  final String name;
  final String description;
  final String solution;

  /// Bobot kepastian (MB) tiap gejala dalam rule, nilai 0.0 - 1.0.
  /// Gejala yang sangat khas terhadap penyakit diberi bobot tinggi,
  /// gejala yang bersifat umum diberi bobot rendah.
  final Map<String, double> symptomWeights;

  const _Rule({
    required this.code,
    required this.name,
    required this.description,
    required this.solution,
    required this.symptomWeights,
  });
}

/// Hasil evaluasi satu rule terhadap fakta pengguna.
class _Evaluated {
  final _Rule rule;
  final double cf;
  final List<String> matched;
  final bool isFullMatch;
  final int order;

  _Evaluated(this.rule, this.cf, this.matched, this.isFullMatch, this.order);
}

/// Engine terpadu Sistem Pakar Pernapasan.
///
/// Metode inferensi utama tetap FORWARD CHAINING sesuai jurnal acuan
/// (Rule 1-5 untuk P01-P05 dengan kombinasi gejala G01-G19 yang sama persis).
/// Sebagai pengembangan, engine ini menambahkan perhitungan CERTAINTY FACTOR
/// (Shortliffe & Buchanan) sehingga:
///   - Kecocokan penuh (full match) menghasilkan diagnosis yang sama persis
///     dengan versi jurnal, kini dilengkapi persentase keyakinan.
///   - Kecocokan parsial tidak lagi langsung "Tidak Teridentifikasi",
///     melainkan menghasilkan kemungkinan penyakit terurut berdasarkan CF.
///
/// Rumus yang dipakai:
///   CF(H,E)   = bobot(MB) x bukti  (bukti = 1 jika gejala dijawab "Ya")
///   CFcombine = CF1 + CF2 x (1 - CF1)   (gabungan bukti paralel positif)
///   CF(H)     = MB(H) - MD(H)  (MD dihitung dari gejala rule yang dijawab "Tidak")
class CertaintyFactorEngine {
  /// Basis aturan: kombinasi gejala identik dengan jurnal (Rule 1-5).
  static final List<_Rule> _rules = [
    const _Rule(
      code: 'P01',
      name: 'Asma',
      description:
          'Penyakit saluran pernapasan kronis yang ditandai dengan peradangan dan penyempitan saluran napas.',
      solution: 'Lakukan pemeriksaan rutin dengan dokter spesialis paru atau poli asma.',
      symptomWeights: {
        'G01': 0.3, // Sesak nafas (gejala umum)
        'G02': 0.5, // Batuk, terutama malam/dini hari
        'G03': 0.7, // Mengi (sangat khas asma)
        'G04': 0.6, // Dada terasa sesak
        'G05': 0.4, // Nafas pendek atau cepat
      },
    ),
    const _Rule(
      code: 'P02',
      name: 'Penyakit Paru Obstruktif Kronis (PPOK)',
      description: 'Kondisi inflamasi paru kronis yang menghalangi aliran udara dari paru-paru.',
      solution: 'Segera konsultasikan ke dokter paru, hindari paparan asap rokok, debu, dan polusi.',
      symptomWeights: {
        'G01': 0.3,
        'G06': 0.6,
        'G07': 0.55,
        'G03': 0.55,
        'G08': 0.25,
        'G09': 0.5,
      },
    ),
    const _Rule(
      code: 'P03',
      name: 'Fibrosis Paru Idiopatik (FPI)',
      description:
          'Penyakit di mana jaringan paru-paru mengalami penebalan, pengerasan, atau jaringan parut.',
      solution: 'Memerlukan evaluasi klinis mendalam, tes fungsi paru, dan penanganan oleh dokter ahli.',
      symptomWeights: {
        'G01': 0.25,
        'G10': 0.6,
        'G08': 0.25,
        'G11': 0.55,
        'G12': 0.3,
        'G13': 0.65,
      },
    ),
    const _Rule(
      code: 'P04',
      name: 'Bronkiektasis',
      description:
          'Kondisi kerusakan pada saluran bronkus di paru-paru yang membuat saluran melebar dan berlendir.',
      solution: 'Pembersihan saluran napas, rehabilitasi paru, dan pemberian antibiotik atas resep dokter.',
      symptomWeights: {
        'G14': 0.65,
        'G09': 0.5,
        'G01': 0.25,
        'G15': 0.4,
        'G03': 0.45,
        'G08': 0.2,
        'G16': 0.7,
      },
    ),
    const _Rule(
      code: 'P05',
      name: 'Sarkoidosis',
      description:
          'Pertumbuhan kumpulan sel peradangan kecil (granuloma) di berbagai organ tubuh, terutama paru-paru.',
      solution: 'Pengawasan medis berkala, pemantauan fungsi organ, dan penanganan inflamasi.',
      symptomWeights: {
        'G01': 0.2,
        'G10': 0.45,
        'G15': 0.4,
        'G08': 0.2,
        'G17': 0.5,
        'G11': 0.5,
        'G18': 0.65,
        'G19': 0.6,
      },
    ),
  ];

  /// Evaluasi diagnosis dengan Forward Chaining + Certainty Factor.
  ///
  /// [yesSymptoms] adalah daftar kode gejala yang dijawab "Ya" oleh pengguna.
  /// Kembalikan map yang kompatibel dengan struktur hasil lama
  /// (code, name, description, solution) dan dilengkapi key baru:
  ///   - confidence      : CF akhir (0.0 - 1.0)
  ///   - isFullMatch     : true jika rule cocok penuh (perilaku jurnal)
  ///   - matchedSymptoms : kode gejala rule utama yang cocok
  ///   - symptomList     : daftar gejala yang dipilih pengguna (kode + nama)
  ///   - alternatives    : kemungkinan penyakit lain (CF > 0, terurut menurun)
  static Map<String, dynamic> evaluateWithCF(List<String> yesSymptoms) {
    final yaSet = yesSymptoms.toSet();

    final List<Map<String, String>> symptomList = yaSet
        .map((code) => {'code': code, 'name': ExpertSystemEngine.symptoms[code] ?? code})
        .toList();

    // --- Forward Chaining: evaluasi semua rule terhadap fakta pengguna ---
    final List<_Evaluated> evaluated = [];
    for (var i = 0; i < _rules.length; i++) {
      final rule = _rules[i];
      double mb = 0.0;
      double md = 0.0;
      final matched = <String>[];
      final missing = <String>[];

      rule.symptomWeights.forEach((code, weight) {
        if (yaSet.contains(code)) {
          mb = _combine(mb, weight); // bukti positif (Ya = 1)
          matched.add(code);
        } else {
          md = _combine(md, weight); // bukti negatif (Tidak menentang)
          missing.add(code);
        }
      });

      double cf = mb - md;
      if (cf < 0) cf = 0.0;
      if (cf > 1) cf = 1.0;

      evaluated.add(_Evaluated(rule, cf, matched, missing.isEmpty, i));
    }

    // Prioritas 1 (sesuai jurnal): rule pertama yang cocok PENUH.
    _Evaluated? primary;
    for (final e in evaluated) {
      if (e.isFullMatch) {
        primary = e;
        break;
      }
    }

    // Prioritas 2 (pengembangan): kecocokan parsial, ambil CF tertinggi.
    if (primary == null) {
      final sorted = [...evaluated]..sort((a, b) {
          final byCf = b.cf.compareTo(a.cf);
          if (byCf != 0) return byCf;
          return a.order.compareTo(b.order); // seri -> urutan rule jurnal
        });
      if (sorted.first.cf > 0) primary = sorted.first;
    }

    // Alternatif: rule lain dengan CF > 0, terurut menurun.
    final alternatives = evaluated
        .where((e) => e != primary && e.cf > 0)
        .map((e) => {'code': e.rule.code, 'name': e.rule.name, 'confidence': e.cf})
        .toList()
      ..sort((a, b) => (b['confidence'] as double).compareTo(a['confidence'] as double));

    if (primary == null) {
      return {
        'code': 'P_UNKNOWN',
        'name': 'Tidak Teridentifikasi / Gejala Belum Spesifik',
        'description':
            'Kombinasi gejala yang Anda pilih belum memenuhi pola pasti penyakit pernapasan kronis dalam basis pengetahuan sistem.',
        'solution':
            'Disarankan untuk tetap melakukan pemeriksaan mandiri lanjutan atau berkonsultasi langsung ke dokter umum/spesialis.',
        'confidence': 0.0,
        'isFullMatch': false,
        'matchedSymptoms': <String>[],
        'symptomList': symptomList,
        'alternatives': alternatives,
      };
    }

    return {
      'code': primary.rule.code,
      'name': primary.rule.name,
      'description': primary.rule.description,
      'solution': primary.rule.solution,
      'confidence': primary.cf,
      'isFullMatch': primary.isFullMatch,
      'matchedSymptoms': primary.matched,
      'symptomList': symptomList,
      'alternatives': alternatives,
    };
  }

  /// Gabungan CF dua bukti paralel (formula standar Certainty Factor):
  /// CFc1,2 = CF1 + CF2 x (1 - CF1)
  static double _combine(double cf1, double cf2) {
    return cf1 + cf2 * (1 - cf1);
  }
}
