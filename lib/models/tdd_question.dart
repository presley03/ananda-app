/// Model untuk pertanyaan Tes Daya Dengar (TDD)
/// Menyimpan pertanyaan berdasarkan rentang usia dan kategori
class TddQuestion {
  final int? id;
  final String
  ageRange; // "<3", "3-6", "6-12", "12-24", "24-36", ">36" (dalam bulan)
  final int questionNumber; // 1-10 atau lebih
  final String questionText; // Pertanyaan lengkap
  final String category; // "Ekspresif", "Reseptif", "Visual"
  final String? imagePath; // Path ke gambar ilustrasi (opsional)

  TddQuestion({
    this.id,
    required this.ageRange,
    required this.questionNumber,
    required this.questionText,
    required this.category,
    this.imagePath,
  });

  /// Format age range untuk display
  /// "<3" → "Kurang dari 3 Bulan"
  /// "3-6" → "3-6 Bulan"
  /// ">36" → "Lebih dari 36 Bulan"
  String get ageRangeDisplay {
    if (ageRange == '<3') {
      return 'Kurang dari 3 Bulan';
    } else if (ageRange == '>36') {
      return 'Lebih dari 36 Bulan';
    } else {
      // Format "3-6", "6-12", dll
      final parts = ageRange.split('-');
      if (parts.length == 2) {
        return '${parts[0]}-${parts[1]} Bulan';
      }
      return '$ageRange Bulan';
    }
  }

  /// Emoji untuk kategori
  String get categoryEmoji {
    switch (category.toLowerCase()) {
      case 'ekspresif':
        return '🗣️';
      case 'reseptif':
        return '👂';
      case 'visual':
        return '👁️';
      default:
        return '❓';
    }
  }

  /// Category dengan emoji
  String get categoryDisplay {
    return '$categoryEmoji $category';
  }

  /// Convert dari Map (dari database atau JSON)
  factory TddQuestion.fromMap(Map<String, dynamic> map) {
    return TddQuestion(
      id: map['id'],
      ageRange: map['age_range'],
      questionNumber: map['question_number'],
      questionText: map['question_text'],
      category: map['category'],
      imagePath: map['image_path'],
    );
  }

  /// Convert ke Map (untuk simpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'age_range': ageRange,
      'question_number': questionNumber,
      'question_text': questionText,
      'category': category,
      'image_path': imagePath,
    };
  }

  /// Copy dengan perubahan tertentu
  TddQuestion copyWith({
    int? id,
    String? ageRange,
    int? questionNumber,
    String? questionText,
    String? category,
    String? imagePath,
  }) {
    return TddQuestion(
      id: id ?? this.id,
      ageRange: ageRange ?? this.ageRange,
      questionNumber: questionNumber ?? this.questionNumber,
      questionText: questionText ?? this.questionText,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'TddQuestion(id: $id, ageRange: $ageRange, questionNumber: $questionNumber, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TddQuestion &&
        other.id == id &&
        other.ageRange == ageRange &&
        other.questionNumber == questionNumber &&
        other.questionText == questionText &&
        other.category == category &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ageRange.hashCode ^
        questionNumber.hashCode ^
        questionText.hashCode ^
        category.hashCode ^
        imagePath.hashCode;
  }
}
