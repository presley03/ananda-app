/// Model untuk pertanyaan M-CHAT-R (Modified Checklist for Autism in Toddlers - Revised)
/// Skrining autisme untuk anak usia 16-30 bulan
class MchatQuestion {
  final int? id;
  final int questionNumber; // 1-20
  final String questionText; // Pertanyaan lengkap
  final bool isCritical; // Apakah pertanyaan kritis (untuk scoring)
  final String? imagePath; // Path ke gambar ilustrasi (opsional)

  MchatQuestion({
    this.id,
    required this.questionNumber,
    required this.questionText,
    required this.isCritical,
    this.imagePath,
  });

  /// Convert dari Map (dari database atau JSON)
  factory MchatQuestion.fromMap(Map<String, dynamic> map) {
    return MchatQuestion(
      id: map['id'],
      questionNumber: map['question_number'],
      questionText: map['question_text'],
      isCritical: map['is_critical'] == 1 || map['is_critical'] == true,
      imagePath: map['image_path'],
    );
  }

  /// Convert ke Map (untuk simpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_number': questionNumber,
      'question_text': questionText,
      'is_critical': isCritical ? 1 : 0,
      'image_path': imagePath,
    };
  }

  /// Copy dengan perubahan tertentu
  MchatQuestion copyWith({
    int? id,
    int? questionNumber,
    String? questionText,
    bool? isCritical,
    String? imagePath,
  }) {
    return MchatQuestion(
      id: id ?? this.id,
      questionNumber: questionNumber ?? this.questionNumber,
      questionText: questionText ?? this.questionText,
      isCritical: isCritical ?? this.isCritical,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'MchatQuestion(id: $id, questionNumber: $questionNumber, isCritical: $isCritical)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MchatQuestion &&
        other.id == id &&
        other.questionNumber == questionNumber &&
        other.questionText == questionText &&
        other.isCritical == isCritical &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        questionNumber.hashCode ^
        questionText.hashCode ^
        isCritical.hashCode ^
        imagePath.hashCode;
  }
}
