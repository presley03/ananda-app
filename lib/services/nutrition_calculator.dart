import '../models/nutrition_measurement.dart';
import '../models/nutrition_result.dart';

/// Service untuk menghitung status gizi anak
/// Menggunakan metode Z-Score sesuai standar WHO
class NutritionCalculator {
  /// Hitung semua Z-Score dari data pengukuran
  ///
  /// Input: NutritionMeasurement (berat, tinggi, umur, gender)
  /// Output: NutritionResult (semua Z-Score dan interpretasi)
  static NutritionResult calculate(NutritionMeasurement measurement) {
    // Hitung Z-Score BB/U (Berat Badan menurut Umur)
    final zScoreWeightForAge = _calculateWeightForAge(
      measurement.weight,
      measurement.ageMonths,
      measurement.gender,
    );

    // Hitung Z-Score PB/U atau TB/U (Panjang/Tinggi Badan menurut Umur)
    final zScoreHeightForAge = _calculateHeightForAge(
      measurement.height,
      measurement.ageMonths,
      measurement.gender,
    );

    // Hitung Z-Score BB/PB atau BB/TB (Berat Badan menurut Panjang/Tinggi Badan)
    final zScoreWeightForHeight = _calculateWeightForHeight(
      measurement.weight,
      measurement.height,
      measurement.ageMonths,
      measurement.gender,
    );

    // Hitung Z-Score IMT/U (IMT menurut Umur)
    final zScoreBMIForAge = _calculateBMIForAge(
      measurement.bmi,
      measurement.ageMonths,
      measurement.gender,
    );

    return NutritionResult(
      zScoreWeightForAge: zScoreWeightForAge,
      zScoreHeightForAge: zScoreHeightForAge,
      zScoreWeightForHeight: zScoreWeightForHeight,
      zScoreBMIForAge: zScoreBMIForAge,
      bmi: measurement.bmi,
    );
  }

  /// Hitung Z-Score BB/U (Berat Badan menurut Umur)
  ///
  /// Rumus: Z = (Nilai Individual - Nilai Median) / Nilai SD
  /// Data referensi: WHO Child Growth Standards
  static double _calculateWeightForAge(
    double weight,
    int ageMonths,
    String gender,
  ) {
    // Data referensi WHO (simplified untuk demo)
    // Dalam implementasi real, pakai tabel lengkap WHO
    final reference = _getWeightForAgeReference(ageMonths, gender);

    return (weight - reference['median']!) / reference['sd']!;
  }

  /// Hitung Z-Score PB/U atau TB/U (Tinggi menurut Umur)
  static double _calculateHeightForAge(
    double height,
    int ageMonths,
    String gender,
  ) {
    final reference = _getHeightForAgeReference(ageMonths, gender);

    return (height - reference['median']!) / reference['sd']!;
  }

  /// Hitung Z-Score BB/PB atau BB/TB (Berat menurut Tinggi)
  static double _calculateWeightForHeight(
    double weight,
    double height,
    int ageMonths,
    String gender,
  ) {
    final reference = _getWeightForHeightReference(height, gender);

    return (weight - reference['median']!) / reference['sd']!;
  }

  /// Hitung Z-Score IMT/U (IMT menurut Umur)
  static double _calculateBMIForAge(double bmi, int ageMonths, String gender) {
    final reference = _getBMIForAgeReference(ageMonths, gender);

    return (bmi - reference['median']!) / reference['sd']!;
  }

  /// Data referensi BB/U dari WHO
  /// CATATAN: Ini data simplified untuk demo
  /// Implementasi lengkap perlu tabel WHO lengkap semua umur
  static Map<String, double> _getWeightForAgeReference(
    int ageMonths,
    String gender,
  ) {
    // Contoh data untuk beberapa umur (Laki-laki)
    // Format: {median: nilai_median, sd: nilai_standar_deviasi}

    if (gender == 'L') {
      // Laki-laki
      if (ageMonths == 0) return {'median': 3.3, 'sd': 0.4};
      if (ageMonths <= 6) return {'median': 7.9, 'sd': 0.8};
      if (ageMonths <= 12) return {'median': 9.6, 'sd': 1.0};
      if (ageMonths <= 24) return {'median': 12.2, 'sd': 1.3};
      if (ageMonths <= 36) return {'median': 14.3, 'sd': 1.5};
      if (ageMonths <= 48) return {'median': 16.3, 'sd': 1.7};
      return {'median': 18.3, 'sd': 2.0}; // 60 bulan
    } else {
      // Perempuan
      if (ageMonths == 0) return {'median': 3.2, 'sd': 0.4};
      if (ageMonths <= 6) return {'median': 7.3, 'sd': 0.8};
      if (ageMonths <= 12) return {'median': 9.0, 'sd': 0.9};
      if (ageMonths <= 24) return {'median': 11.5, 'sd': 1.2};
      if (ageMonths <= 36) return {'median': 13.9, 'sd': 1.5};
      if (ageMonths <= 48) return {'median': 16.0, 'sd': 1.8};
      return {'median': 18.2, 'sd': 2.2}; // 60 bulan
    }
  }

  /// Data referensi PB/U atau TB/U dari WHO
  static Map<String, double> _getHeightForAgeReference(
    int ageMonths,
    String gender,
  ) {
    if (gender == 'L') {
      // Laki-laki
      if (ageMonths == 0) return {'median': 49.9, 'sd': 1.9};
      if (ageMonths <= 6) return {'median': 67.6, 'sd': 2.0};
      if (ageMonths <= 12) return {'median': 75.7, 'sd': 2.2};
      if (ageMonths <= 24) return {'median': 87.1, 'sd': 2.5};
      if (ageMonths <= 36) return {'median': 96.1, 'sd': 2.7};
      if (ageMonths <= 48) return {'median': 103.3, 'sd': 2.9};
      return {'median': 110.0, 'sd': 3.2}; // 60 bulan
    } else {
      // Perempuan
      if (ageMonths == 0) return {'median': 49.1, 'sd': 1.9};
      if (ageMonths <= 6) return {'median': 65.7, 'sd': 2.0};
      if (ageMonths <= 12) return {'median': 74.0, 'sd': 2.1};
      if (ageMonths <= 24) return {'median': 85.7, 'sd': 2.5};
      if (ageMonths <= 36) return {'median': 95.1, 'sd': 2.8};
      if (ageMonths <= 48) return {'median': 102.7, 'sd': 3.0};
      return {'median': 109.4, 'sd': 3.4}; // 60 bulan
    }
  }

  /// Data referensi BB/PB atau BB/TB dari WHO
  static Map<String, double> _getWeightForHeightReference(
    double height,
    String gender,
  ) {
    // Simplified berdasarkan rentang tinggi
    if (gender == 'L') {
      // Laki-laki
      if (height < 55) return {'median': 4.5, 'sd': 0.5};
      if (height < 65) return {'median': 7.0, 'sd': 0.7};
      if (height < 75) return {'median': 9.0, 'sd': 0.9};
      if (height < 85) return {'median': 11.0, 'sd': 1.1};
      if (height < 95) return {'median': 13.5, 'sd': 1.3};
      if (height < 105) return {'median': 16.0, 'sd': 1.6};
      return {'median': 18.5, 'sd': 2.0};
    } else {
      // Perempuan
      if (height < 55) return {'median': 4.2, 'sd': 0.5};
      if (height < 65) return {'median': 6.5, 'sd': 0.7};
      if (height < 75) return {'median': 8.5, 'sd': 0.8};
      if (height < 85) return {'median': 10.5, 'sd': 1.0};
      if (height < 95) return {'median': 13.0, 'sd': 1.3};
      if (height < 105) return {'median': 15.5, 'sd': 1.6};
      return {'median': 18.0, 'sd': 2.0};
    }
  }

  /// Data referensi IMT/U dari WHO
  static Map<String, double> _getBMIForAgeReference(
    int ageMonths,
    String gender,
  ) {
    if (gender == 'L') {
      // Laki-laki
      if (ageMonths == 0) return {'median': 13.4, 'sd': 1.2};
      if (ageMonths <= 6) return {'median': 17.3, 'sd': 1.5};
      if (ageMonths <= 12) return {'median': 16.9, 'sd': 1.3};
      if (ageMonths <= 24) return {'median': 16.2, 'sd': 1.3};
      if (ageMonths <= 36) return {'median': 15.8, 'sd': 1.2};
      if (ageMonths <= 48) return {'median': 15.5, 'sd': 1.2};
      return {'median': 15.3, 'sd': 1.3}; // 60 bulan
    } else {
      // Perempuan
      if (ageMonths == 0) return {'median': 13.3, 'sd': 1.2};
      if (ageMonths <= 6) return {'median': 16.8, 'sd': 1.5};
      if (ageMonths <= 12) return {'median': 16.4, 'sd': 1.3};
      if (ageMonths <= 24) return {'median': 16.0, 'sd': 1.3};
      if (ageMonths <= 36) return {'median': 15.6, 'sd': 1.3};
      if (ageMonths <= 48) return {'median': 15.4, 'sd': 1.3};
      return {'median': 15.2, 'sd': 1.4}; // 60 bulan
    }
  }
}
