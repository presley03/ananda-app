/// Child Profile Model
/// Model untuk data profil anak
/// 
/// Fields:
/// - id: Primary key (auto-increment)
/// - name: Nama anak
/// - birthDate: Tanggal lahir
/// - gender: Jenis kelamin (L/P)
/// - photoPath: Path foto profil (opsional)
/// - createdAt: Waktu dibuat
/// - updatedAt: Waktu diupdate
class ChildProfile {
  final int? id;
  final String name;
  final DateTime birthDate;
  final String gender; // 'L' atau 'P'
  final String? photoPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChildProfile({
    this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.photoPath,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert from database map to ChildProfile object
  factory ChildProfile.fromMap(Map<String, dynamic> map) {
    return ChildProfile(
      id: map['id'] as int?,
      name: map['name'] as String,
      birthDate: DateTime.parse(map['birth_date'] as String),
      gender: map['gender'] as String,
      photoPath: map['photo_path'] as String?,
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  /// Convert ChildProfile object to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      'photo_path': photoPath,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updated_at': updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  /// Get age in months (untuk keperluan skrining)
  int get ageInMonths {
    final now = DateTime.now();
    final difference = now.difference(birthDate);
    return (difference.inDays / 30.44).floor(); // Average days per month
  }

  /// Get age in years and months (untuk display)
  /// Returns: "2 tahun 3 bulan" atau "6 bulan"
  String get ageDescription {
    final months = ageInMonths;
    final years = months ~/ 12;
    final remainingMonths = months % 12;

    if (years == 0) {
      return '$months bulan';
    } else if (remainingMonths == 0) {
      return '$years tahun';
    } else {
      return '$years tahun $remainingMonths bulan';
    }
  }

  /// Get gender display text
  String get genderDisplay {
    return gender == 'L' ? 'Laki-laki' : 'Perempuan';
  }

  /// Get appropriate KPSP age category
  /// KPSP tersedia untuk: 3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72 bulan
  int? get kpspAgeCategory {
    final months = ageInMonths;
    
    // KPSP age categories
    const categories = [3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72];
    
    // Find the closest category (rounded down)
    for (int i = categories.length - 1; i >= 0; i--) {
      if (months >= categories[i]) {
        return categories[i];
      }
    }
    
    // Terlalu muda untuk KPSP (< 3 bulan)
    return null;
  }

  /// Check if eligible for M-CHAT-R screening (16-30 months)
  bool get isEligibleForMCHAT {
    final months = ageInMonths;
    return months >= 16 && months <= 30;
  }

  /// Get material category based on age
  /// Returns: '0-1', '1-2', or '2-5'
  String get materialCategory {
    final months = ageInMonths;
    if (months <= 12) {
      return '0-1';
    } else if (months <= 24) {
      return '1-2';
    } else {
      return '2-5';
    }
  }

  /// Copy with (untuk update data)
  ChildProfile copyWith({
    int? id,
    String? name,
    DateTime? birthDate,
    String? gender,
    String? photoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ChildProfile(id: $id, name: $name, age: $ageDescription, gender: $genderDisplay)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChildProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
