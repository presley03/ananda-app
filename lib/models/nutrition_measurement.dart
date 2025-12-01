/// Model untuk data pengukuran status gizi anak
/// Menyimpan: berat, tinggi, umur, jenis kelamin
class NutritionMeasurement {
  final int? id;
  final double weight; // Berat badan dalam kg
  final double height; // Tinggi/panjang badan dalam cm
  final int ageMonths; // Umur dalam bulan
  final String gender; // 'L' atau 'P'
  final DateTime measurementDate;

  NutritionMeasurement({
    this.id,
    required this.weight,
    required this.height,
    required this.ageMonths,
    required this.gender,
    required this.measurementDate,
  });

  /// Hitung IMT (Indeks Massa Tubuh)
  /// Rumus: BB (kg) / TB² (m²)
  double get bmi {
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  /// Cek apakah pakai Panjang Badan (PB) atau Tinggi Badan (TB)
  /// PB = anak < 24 bulan (ukur berbaring)
  /// TB = anak >= 24 bulan (ukur berdiri)
  String get measurementType {
    return ageMonths < 24 ? 'PB' : 'TB';
  }

  /// Format umur untuk display (contoh: "3 Bulan", "1 Tahun 2 Bulan")
  String get ageDisplay {
    if (ageMonths < 12) {
      return '$ageMonths Bulan';
    } else {
      final years = ageMonths ~/ 12;
      final months = ageMonths % 12;
      if (months == 0) {
        return '$years Tahun';
      }
      return '$years Tahun $months Bulan';
    }
  }

  /// Format jenis kelamin untuk display
  String get genderDisplay {
    return gender == 'L' ? 'Laki-laki' : 'Perempuan';
  }

  /// Convert dari Map (dari database atau form)
  factory NutritionMeasurement.fromMap(Map<String, dynamic> map) {
    return NutritionMeasurement(
      id: map['id'],
      weight: map['weight'].toDouble(),
      height: map['height'].toDouble(),
      ageMonths: map['age_months'],
      gender: map['gender'],
      measurementDate: DateTime.parse(map['measurement_date']),
    );
  }

  /// Convert ke Map (untuk simpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight': weight,
      'height': height,
      'age_months': ageMonths,
      'gender': gender,
      'measurement_date': measurementDate.toIso8601String(),
    };
  }

  /// Copy dengan perubahan tertentu
  NutritionMeasurement copyWith({
    int? id,
    double? weight,
    double? height,
    int? ageMonths,
    String? gender,
    DateTime? measurementDate,
  }) {
    return NutritionMeasurement(
      id: id ?? this.id,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      ageMonths: ageMonths ?? this.ageMonths,
      gender: gender ?? this.gender,
      measurementDate: measurementDate ?? this.measurementDate,
    );
  }

  @override
  String toString() {
    return 'NutritionMeasurement(id: $id, weight: $weight kg, height: $height cm, age: $ageMonths months, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NutritionMeasurement &&
        other.id == id &&
        other.weight == weight &&
        other.height == height &&
        other.ageMonths == ageMonths &&
        other.gender == gender &&
        other.measurementDate == measurementDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        weight.hashCode ^
        height.hashCode ^
        ageMonths.hashCode ^
        gender.hashCode ^
        measurementDate.hashCode;
  }
}
