/// Model untuk hasil perhitungan status gizi
/// Menyimpan Z-Score dan interpretasi kategori gizi
class NutritionResult {
  final double zScoreWeightForAge; // Z-Score BB/U
  final double zScoreHeightForAge; // Z-Score PB/U atau TB/U
  final double zScoreWeightForHeight; // Z-Score BB/PB atau BB/TB
  final double zScoreBMIForAge; // Z-Score IMT/U
  final double bmi; // IMT value

  NutritionResult({
    required this.zScoreWeightForAge,
    required this.zScoreHeightForAge,
    required this.zScoreWeightForHeight,
    required this.zScoreBMIForAge,
    required this.bmi,
  });

  /// Interpretasi BB/U (Berat Badan menurut Umur)
  /// Berdasarkan Permenkes No. 2 Tahun 2020
  String get weightForAgeStatus {
    if (zScoreWeightForAge < -3) {
      return 'Berat badan sangat kurang';
    } else if (zScoreWeightForAge >= -3 && zScoreWeightForAge < -2) {
      return 'Berat badan kurang';
    } else if (zScoreWeightForAge >= -2 && zScoreWeightForAge <= 1) {
      return 'Berat badan normal';
    } else {
      return 'Risiko berat badan lebih';
    }
  }

  /// Interpretasi PB/U atau TB/U (Panjang/Tinggi Badan menurut Umur)
  String get heightForAgeStatus {
    if (zScoreHeightForAge < -3) {
      return 'Sangat pendek';
    } else if (zScoreHeightForAge >= -3 && zScoreHeightForAge < -2) {
      return 'Pendek';
    } else if (zScoreHeightForAge >= -2 && zScoreHeightForAge <= 3) {
      return 'Normal';
    } else {
      return 'Tinggi';
    }
  }

  /// Interpretasi BB/PB atau BB/TB (Berat Badan menurut Panjang/Tinggi Badan)
  String get weightForHeightStatus {
    if (zScoreWeightForHeight < -3) {
      return 'Gizi buruk';
    } else if (zScoreWeightForHeight >= -3 && zScoreWeightForHeight < -2) {
      return 'Gizi kurang';
    } else if (zScoreWeightForHeight >= -2 && zScoreWeightForHeight <= 1) {
      return 'Gizi baik';
    } else if (zScoreWeightForHeight > 1 && zScoreWeightForHeight <= 2) {
      return 'Berisiko gizi lebih';
    } else if (zScoreWeightForHeight > 2 && zScoreWeightForHeight <= 3) {
      return 'Gizi lebih';
    } else {
      return 'Obesitas';
    }
  }

  /// Interpretasi IMT/U (Indeks Massa Tubuh menurut Umur)
  /// Untuk anak 0-60 bulan
  String get bmiForAgeStatus {
    if (zScoreBMIForAge < -3) {
      return 'Gizi buruk';
    } else if (zScoreBMIForAge >= -3 && zScoreBMIForAge < -2) {
      return 'Gizi kurang';
    } else if (zScoreBMIForAge >= -2 && zScoreBMIForAge <= 1) {
      return 'Gizi baik';
    } else if (zScoreBMIForAge > 1 && zScoreBMIForAge <= 2) {
      return 'Berisiko gizi lebih';
    } else if (zScoreBMIForAge > 2 && zScoreBMIForAge <= 3) {
      return 'Gizi lebih';
    } else {
      return 'Obesitas';
    }
  }

  /// Status keseluruhan (ringkasan)
  /// Prioritas: BB/TB atau IMT/U (paling akurat)
  String get overallStatus {
    return weightForHeightStatus;
  }

  /// Warna untuk status (untuk UI)
  String get statusColor {
    final status = overallStatus.toLowerCase();
    if (status.contains('buruk') || status.contains('sangat')) {
      return 'danger'; // Merah
    } else if (status.contains('kurang') || status.contains('pendek')) {
      return 'warning'; // Orange
    } else if (status.contains('normal') || status.contains('baik')) {
      return 'success'; // Hijau
    } else if (status.contains('risiko') || status.contains('lebih')) {
      return 'warning'; // Orange
    } else if (status.contains('obesitas')) {
      return 'danger'; // Merah
    }
    return 'info'; // Biru default
  }

  /// Rekomendasi berdasarkan status
  String get recommendation {
    final status = overallStatus.toLowerCase();

    if (status.contains('buruk') || status.contains('sangat kurang')) {
      return 'Segera konsultasi dengan dokter atau ahli gizi. Anak memerlukan penanganan medis dan perbaikan asupan nutrisi.';
    } else if (status.contains('kurang')) {
      return 'Tingkatkan asupan nutrisi anak dengan makanan bergizi seimbang. Konsultasi dengan tenaga kesehatan untuk panduan lebih lanjut.';
    } else if (status.contains('normal') || status.contains('baik')) {
      return 'Pertahankan pola makan sehat dan seimbang. Lanjutkan pemantauan pertumbuhan secara berkala.';
    } else if (status.contains('risiko') || status.contains('lebih')) {
      return 'Perhatikan asupan makanan anak. Kurangi makanan tinggi kalori dan tingkatkan aktivitas fisik. Konsultasi dengan ahli gizi jika diperlukan.';
    } else if (status.contains('obesitas')) {
      return 'Konsultasi dengan dokter atau ahli gizi untuk program penurunan berat badan yang sehat dan aman untuk anak.';
    } else if (status.contains('sangat pendek') || status.contains('pendek')) {
      return 'Anak mengalami stunting. Penting untuk meningkatkan asupan nutrisi dan stimulasi. Konsultasi dengan tenaga kesehatan.';
    }

    return 'Lanjutkan pemantauan pertumbuhan anak secara berkala.';
  }

  /// Format Z-Score untuk display (2 desimal)
  String formatZScore(double zScore) {
    return zScore.toStringAsFixed(2);
  }

  /// Convert ke Map (untuk simpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'z_score_weight_for_age': zScoreWeightForAge,
      'z_score_height_for_age': zScoreHeightForAge,
      'z_score_weight_for_height': zScoreWeightForHeight,
      'z_score_bmi_for_age': zScoreBMIForAge,
      'bmi': bmi,
      'overall_status': overallStatus,
      'recommendation': recommendation,
    };
  }

  /// Convert dari Map
  factory NutritionResult.fromMap(Map<String, dynamic> map) {
    return NutritionResult(
      zScoreWeightForAge: map['z_score_weight_for_age'].toDouble(),
      zScoreHeightForAge: map['z_score_height_for_age'].toDouble(),
      zScoreWeightForHeight: map['z_score_weight_for_height'].toDouble(),
      zScoreBMIForAge: map['z_score_bmi_for_age'].toDouble(),
      bmi: map['bmi'].toDouble(),
    );
  }

  @override
  String toString() {
    return 'NutritionResult(BB/U: ${formatZScore(zScoreWeightForAge)}, PB/U: ${formatZScore(zScoreHeightForAge)}, BB/PB: ${formatZScore(zScoreWeightForHeight)}, IMT/U: ${formatZScore(zScoreBMIForAge)}, Status: $overallStatus)';
  }
}
