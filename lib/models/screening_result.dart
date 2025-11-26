/// Screening Result Model
/// Model untuk hasil skrining (KPSP, TDD, M-CHAT-R, Gizi)
/// 
/// Fields:
/// - id: Primary key
/// - childId: ID anak yang dites
/// - screeningType: Jenis skrining (KPSP, TDD, MCHAT, GIZI)
/// - ageMonths: Usia anak saat skrining (dalam bulan)
/// - score: Skor hasil skrining (jika ada)
/// - result: Hasil interpretasi (Sesuai, Meragukan, dll)
/// - details: Detail hasil dalam JSON format
/// - notes: Catatan tambahan
/// - createdAt: Waktu skrining dilakukan
class ScreeningResult {
  final int? id;
  final int childId;
  final String screeningType;
  final int ageMonths;
  final int? score;
  final String result;
  final String? details;
  final String? notes;
  final DateTime? createdAt;

  ScreeningResult({
    this.id,
    required this.childId,
    required this.screeningType,
    required this.ageMonths,
    this.score,
    required this.result,
    this.details,
    this.notes,
    this.createdAt,
  });

  /// Convert from database map to ScreeningResult object
  factory ScreeningResult.fromMap(Map<String, dynamic> map) {
    return ScreeningResult(
      id: map['id'] as int?,
      childId: map['child_id'] as int,
      screeningType: map['screening_type'] as String,
      ageMonths: map['age_months'] as int,
      score: map['score'] as int?,
      result: map['result'] as String,
      details: map['details'] as String?,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  /// Convert ScreeningResult object to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'child_id': childId,
      'screening_type': screeningType,
      'age_months': ageMonths,
      'score': score,
      'result': result,
      'details': details,
      'notes': notes,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  /// Get screening type display name
  String get screeningTypeDisplay {
    switch (screeningType.toUpperCase()) {
      case 'KPSP':
        return 'KPSP - Perkembangan';
      case 'TDD':
        return 'TDD - Daya Dengar';
      case 'MCHAT':
        return 'M-CHAT-R - Autisme';
      case 'GIZI':
        return 'Status Gizi';
      default:
        return screeningType;
    }
  }

  /// Get result status color indicator
  /// Returns: 'success', 'warning', 'danger'
  String get resultColorStatus {
    final resultLower = result.toLowerCase();
    
    if (resultLower.contains('sesuai') || 
        resultLower.contains('normal') ||
        resultLower.contains('gizi baik')) {
      return 'success';
    } else if (resultLower.contains('meragukan') || 
               resultLower.contains('risiko rendah') ||
               resultLower.contains('gizi kurang') ||
               resultLower.contains('gizi lebih')) {
      return 'warning';
    } else {
      return 'danger';
    }
  }

  /// Get result emoji
  String get resultEmoji {
    switch (resultColorStatus) {
      case 'success':
        return '✅';
      case 'warning':
        return '⚠️';
      case 'danger':
        return '❌';
      default:
        return '📋';
    }
  }

  /// Get formatted date
  String get formattedDate {
    if (createdAt == null) return '-';
    
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    
    return '${createdAt!.day} ${months[createdAt!.month - 1]} ${createdAt!.year}';
  }

  /// Get age description at screening
  String get ageDescription {
    final years = ageMonths ~/ 12;
    final remainingMonths = ageMonths % 12;

    if (years == 0) {
      return '$ageMonths bulan';
    } else if (remainingMonths == 0) {
      return '$years tahun';
    } else {
      return '$years tahun $remainingMonths bulan';
    }
  }

  /// Check if result needs follow-up
  bool get needsFollowUp {
    return resultColorStatus == 'warning' || resultColorStatus == 'danger';
  }

  /// Get recommendation message based on result
  String get recommendationMessage {
    final resultLower = result.toLowerCase();
    
    if (resultLower.contains('sesuai') || resultLower.contains('normal')) {
      return 'Pertahankan stimulasi dan pola asuh yang baik. Ulangi skrining sesuai jadwal.';
    } else if (resultLower.contains('meragukan')) {
      return 'Lakukan skrining ulang 2 minggu kemudian. Tingkatkan stimulasi di rumah.';
    } else if (resultLower.contains('penyimpangan')) {
      return 'Segera konsultasi dengan dokter spesialis anak atau tenaga kesehatan profesional.';
    } else if (resultLower.contains('risiko tinggi')) {
      return 'Segera rujuk ke dokter spesialis anak untuk evaluasi lebih lanjut.';
    } else if (resultLower.contains('gizi kurang') || resultLower.contains('gizi buruk')) {
      return 'Konsultasi dengan ahli gizi dan dokter anak untuk penanganan segera.';
    } else {
      return 'Konsultasi dengan tenaga kesehatan untuk evaluasi lebih lanjut.';
    }
  }

  /// Copy with (untuk update data)
  ScreeningResult copyWith({
    int? id,
    int? childId,
    String? screeningType,
    int? ageMonths,
    int? score,
    String? result,
    String? details,
    String? notes,
    DateTime? createdAt,
  }) {
    return ScreeningResult(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      screeningType: screeningType ?? this.screeningType,
      ageMonths: ageMonths ?? this.ageMonths,
      score: score ?? this.score,
      result: result ?? this.result,
      details: details ?? this.details,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ScreeningResult(id: $id, type: $screeningType, result: $result, age: $ageDescription)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScreeningResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
