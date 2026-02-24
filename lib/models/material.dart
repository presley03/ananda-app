/// Material Model
/// Model untuk data materi edukatif
///
/// Fields:
/// - id: Primary key
/// - category: Kategori usia ('0-1', '1-2', '2-5')
/// - subcategory: Sub-kategori (Pertumbuhan, Perkembangan, Nutrisi, Stimulasi, Perawatan)
/// - title: Judul materi
/// - content: Konten materi (text)
/// - tags: Tags untuk pencarian (comma-separated)
/// - createdAt: Waktu dibuat
class Material {
  final int? id;
  final String category;
  final String subcategory;
  final String title;
  final String? image;
  final String content;
  final String? tags;
  final DateTime? createdAt;

  Material({
    this.id,
    required this.category,
    required this.subcategory,
    required this.title,
    this.image,
    required this.content,
    this.tags,
    this.createdAt,
  });

  /// Convert from database map to Material object
  factory Material.fromMap(Map<String, dynamic> map) {
    return Material(
      id: map['id'] as int?,
      category: map['category'] as String,
      subcategory: map['subcategory'] as String,
      title: map['title'] as String,
      image: map['image'] as String?,
      content: map['content'] as String,
      tags: map['tags'] as String?,
      createdAt:
          map['created_at'] != null
              ? DateTime.parse(map['created_at'] as String)
              : null,
    );
  }

  /// Convert Material object to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'subcategory': subcategory,
      'title': title,
      'image': image,
      'content': content,
      'tags': tags,
      'created_at':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  /// Get category display name
  String get categoryDisplay {
    switch (category) {
      case '0-1':
        return '0-1 Tahun';
      case '1-2':
        return '1-2 Tahun';
      case '2-5':
        return '2-5 Tahun';
      default:
        return category;
    }
  }

  /// Get subcategory display name with emoji
  String get subcategoryDisplay {
    switch (subcategory.toLowerCase()) {
      case 'pertumbuhan':
        return '📏 Pertumbuhan';
      case 'perkembangan':
        return '🧠 Perkembangan';
      case 'nutrisi':
        return '🍎 Nutrisi';
      case 'stimulasi':
        return '🎨 Stimulasi';
      case 'perawatan':
        return '❤️ Perawatan';
      default:
        return subcategory;
    }
  }

  /// Get list of tags
  List<String> get tagList {
    if (tags == null || tags!.isEmpty) return [];
    return tags!.split(',').map((tag) => tag.trim()).toList();
  }

  /// Check if material matches search keyword
  bool matchesKeyword(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    return title.toLowerCase().contains(lowerKeyword) ||
        content.toLowerCase().contains(lowerKeyword) ||
        (tags?.toLowerCase().contains(lowerKeyword) ?? false);
  }

  /// Get content preview (first 100 characters)
  String get contentPreview {
    final cleaned = content.replaceAll('**', '');
    if (cleaned.length <= 100) return cleaned;
    return '${cleaned.substring(0, 100)}...';
  }

  /// Get estimated reading time in minutes
  int get estimatedReadingTime {
    // Average reading speed: 200 words per minute
    final wordCount = content.split(RegExp(r'\s+')).length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  /// Copy with (untuk update data)
  Material copyWith({
    int? id,
    String? category,
    String? subcategory,
    String? title,
    String? image,
    String? content,
    String? tags,
    DateTime? createdAt,
  }) {
    return Material(
      id: id ?? this.id,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      title: title ?? this.title,
      image: image ?? this.image,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Material(id: $id, category: $category, subcategory: $subcategory, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Material && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
