/// UserProfile Model
/// Model untuk data profil pengguna/pengasuh
/// 
/// Fields:
/// - id: Always 1 (single user app)
/// - name: Nama pengguna (e.g., "Ibu Siti")
/// - role: Hubungan dengan anak (Ibu/Ayah/Nenek/dll)
/// - photoPath: Path ke foto profil (optional)
/// - location: Lokasi/kota (optional)
/// - createdAt: Waktu dibuat
/// - updatedAt: Waktu terakhir diupdate
///
/// Future fields (commented, for online version):
/// - userId: Server user ID
/// - email: Email untuk authentication
/// - phone: Nomor telepon
/// - authToken: Authentication token
/// - lastSyncedAt: Kapan terakhir sync
/// - isSynced: Status sync (0/1)
class UserProfile {
  final int id;
  final String name;
  final String role; // Ibu, Ayah, Nenek, Kakek, Pengasuh, Nakes
  final String? photoPath;
  final String? location;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Future fields (for online version)
  // final String? userId;
  // final String? email;
  // final String? phone;
  // final String? authToken;
  // final DateTime? lastSyncedAt;
  // final bool isSynced;

  UserProfile({
    this.id = 1, // Always 1 for single user
    required this.name,
    required this.role,
    this.photoPath,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert from database map to UserProfile object
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as int? ?? 1,
      name: map['name'] as String,
      role: map['role'] as String,
      photoPath: map['photo_path'] as String?,
      location: map['location'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  /// Convert UserProfile object to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'photo_path': photoPath,
      'location': location,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updated_at': updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  /// Get role display with emoji
  String get roleDisplay {
    switch (role) {
      case 'Ibu':
        return '👩 Ibu';
      case 'Ayah':
        return '👨 Ayah';
      case 'Nenek':
        return '👵 Nenek';
      case 'Kakek':
        return '👴 Kakek';
      case 'Pengasuh':
        return '👤 Pengasuh';
      case 'Nakes':
        return '⚕️ Tenaga Kesehatan';
      default:
        return role;
    }
  }

  /// Get short greeting (e.g., "Ibu Siti")
  String get shortGreeting {
    return '$role $name';
  }

  /// Get full greeting based on time
  String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Selamat pagi';
    } else if (hour < 15) {
      greeting = 'Selamat siang';
    } else if (hour < 18) {
      greeting = 'Selamat sore';
    } else {
      greeting = 'Selamat malam';
    }

    return '$greeting, $role $name!';
  }

  /// Check if profile is complete
  bool get isComplete {
    return name.isNotEmpty && role.isNotEmpty;
  }

  /// Copy with (untuk update data)
  UserProfile copyWith({
    int? id,
    String? name,
    String? role,
    String? photoPath,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      photoPath: photoPath ?? this.photoPath,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  /// Get available roles
  static List<String> get availableRoles => [
        'Ibu',
        'Ayah',
        'Nenek',
        'Kakek',
        'Pengasuh',
        'Nakes',
      ];
}
