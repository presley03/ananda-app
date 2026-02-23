class ChildProfile {
  final int? id;
  final String name;
  final DateTime birthDate;
  final String gender;
  final String? photoPath;
  final String? birthPlace;
  final String? identityNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChildProfile({
    this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.photoPath,
    this.birthPlace,
    this.identityNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory ChildProfile.fromMap(Map<String, dynamic> map) {
    return ChildProfile(
      id: map['id'] as int?,
      name: map['name'] as String,
      birthDate: DateTime.parse(map['birth_date'] as String),
      gender: map['gender'] as String,
      photoPath: map['photo_path'] as String?,
      birthPlace: map['birth_place'] as String?,
      identityNumber: map['identity_number'] as String?,
      createdAt:
          map['created_at'] != null
              ? DateTime.parse(map['created_at'] as String)
              : null,
      updatedAt:
          map['updated_at'] != null
              ? DateTime.parse(map['updated_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate.toIso8601String(),
      'gender': gender,
      'photo_path': photoPath,
      'birth_place': birthPlace,
      'identity_number': identityNumber,
      'created_at':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updated_at':
          updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  int get ageInMonths {
    final now = DateTime.now();
    return ((now.difference(birthDate).inDays) / 30.44).floor();
  }

  String get ageDescription {
    final months = ageInMonths;
    final years = months ~/ 12;
    final rem = months % 12;
    if (years == 0) return '$months bulan';
    if (rem == 0) return '$years tahun';
    return '$years tahun $rem bulan';
  }

  String get genderDisplay => gender == 'L' ? 'Laki-laki' : 'Perempuan';

  int? get kpspAgeCategory {
    final months = ageInMonths;
    const cats = [3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72];
    for (int i = cats.length - 1; i >= 0; i--) {
      if (months >= cats[i]) return cats[i];
    }
    return null;
  }

  bool get isEligibleForMCHAT {
    final months = ageInMonths;
    return months >= 16 && months <= 30;
  }

  String get materialCategory {
    final months = ageInMonths;
    if (months <= 12) return '0-1';
    if (months <= 24) return '1-2';
    return '2-5';
  }

  ChildProfile copyWith({
    int? id,
    String? name,
    DateTime? birthDate,
    String? gender,
    String? photoPath,
    String? birthPlace,
    String? identityNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      photoPath: photoPath ?? this.photoPath,
      birthPlace: birthPlace ?? this.birthPlace,
      identityNumber: identityNumber ?? this.identityNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'ChildProfile(id: $id, name: $name, age: $ageDescription)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChildProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
