/// KPSP Question Model
/// Model untuk data pertanyaan KPSP (Kuesioner Pra Skrining Perkembangan)
///
/// Fields:
/// - id: Primary key
/// - ageMonths: Umur anak dalam bulan (3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72)
/// - questionNumber: Nomor pertanyaan (1-10)
/// - questionText: Teks pertanyaan
/// - aspect: Aspek perkembangan (Motorik Kasar, Motorik Halus, Bicara & Bahasa, Sosialisasi & Kemandirian)
/// - imagePath: Path ke gambar ilustrasi (optional)
class KpspQuestion {
  final int? id;
  final int ageMonths;
  final int questionNumber;
  final String questionText;
  final String aspect;
  final String? imagePath;

  KpspQuestion({
    this.id,
    required this.ageMonths,
    required this.questionNumber,
    required this.questionText,
    required this.aspect,
    this.imagePath,
  });

  /// Convert from database map to KpspQuestion object
  factory KpspQuestion.fromMap(Map<String, dynamic> map) {
    return KpspQuestion(
      id: map['id'] as int?,
      ageMonths: map['age_months'] as int,
      questionNumber: map['question_number'] as int,
      questionText: map['question_text'] as String,
      aspect: map['aspect'] as String,
      imagePath: map['image_path'] as String?,
    );
  }

  /// Convert KpspQuestion object to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'age_months': ageMonths,
      'question_number': questionNumber,
      'question_text': questionText,
      'aspect': aspect,
      'image_path': imagePath,
    };
  }

  /// Get age display name
  String get ageDisplay {
    if (ageMonths < 12) {
      return '$ageMonths Bulan';
    } else {
      final years = ageMonths ~/ 12;
      final months = ageMonths % 12;
      if (months == 0) {
        return '$years Tahun';
      } else {
        return '$years Tahun $months Bulan';
      }
    }
  }

  /// Get aspect emoji
  String get aspectEmoji {
    switch (aspect.toLowerCase()) {
      case 'motorik kasar':
        return '🏃';
      case 'motorik halus':
        return '✋';
      case 'bicara & bahasa':
      case 'bicara dan bahasa':
        return '💬';
      case 'sosialisasi & kemandirian':
      case 'sosialisasi dan kemandirian':
        return '👥';
      default:
        return '📝';
    }
  }

  /// Get aspect display with emoji
  String get aspectDisplay {
    return '$aspectEmoji $aspect';
  }

  /// Copy with (untuk update data)
  KpspQuestion copyWith({
    int? id,
    int? ageMonths,
    int? questionNumber,
    String? questionText,
    String? aspect,
    String? imagePath,
  }) {
    return KpspQuestion(
      id: id ?? this.id,
      ageMonths: ageMonths ?? this.ageMonths,
      questionNumber: questionNumber ?? this.questionNumber,
      questionText: questionText ?? this.questionText,
      aspect: aspect ?? this.aspect,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'KpspQuestion(id: $id, age: $ageMonths months, question: $questionNumber, aspect: $aspect)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KpspQuestion && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
