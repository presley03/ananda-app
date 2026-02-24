import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/constants/app_info.dart';
import '../models/user_profile.dart';

/// Database Service
/// Mengelola semua operasi database SQLite untuk aplikasi Ananda
///
/// Features:
/// - Inisialisasi database
/// - CRUD operations untuk semua tabel
/// - Pre-populate data materi dan KPSP
/// - User profile management (NEW!)
/// - Auto-migration dari v1 ke v2
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppInfo.databaseName);

    return await openDatabase(
      path,
      version: AppInfo.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create tables on first launch
  Future<void> _onCreate(Database db, int version) async {
    // Table: children (profil anak)
    await db.execute('''
      CREATE TABLE children (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        birth_date TEXT NOT NULL,
        gender TEXT CHECK(gender IN ('L', 'P')),
        photo_path TEXT,
        birth_place TEXT,
        identity_number TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Table: screening_results (hasil skrining)
    await db.execute('''
      CREATE TABLE screening_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id INTEGER NOT NULL,
        screening_type TEXT NOT NULL,
        age_months INTEGER NOT NULL,
        score INTEGER,
        result TEXT NOT NULL,
        details TEXT,
        notes TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (child_id) REFERENCES children(id) ON DELETE CASCADE
      )
    ''');

    // Table: materials (materi edukatif)
    await db.execute('''
      CREATE TABLE materials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        subcategory TEXT NOT NULL,
        title TEXT NOT NULL,
        image TEXT,
        content TEXT NOT NULL,
        tags TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Table: kpsp_questions (pertanyaan KPSP)
    await db.execute('''
      CREATE TABLE kpsp_questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        age_months INTEGER NOT NULL,
        question_number INTEGER NOT NULL,
        question_text TEXT NOT NULL,
        aspect TEXT NOT NULL,
        image_path TEXT
      )
    ''');

    // Table: tdd_questions (pertanyaan TDD)
    await db.execute('''
      CREATE TABLE tdd_questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        age_range TEXT NOT NULL,
        question_text TEXT NOT NULL,
        question_type TEXT NOT NULL
      )
    ''');

    // Table: mchat_questions (pertanyaan M-CHAT-R)
    await db.execute('''
      CREATE TABLE mchat_questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_number INTEGER NOT NULL,
        question_text TEXT NOT NULL,
        critical_item INTEGER DEFAULT 0
      )
    ''');

    // Table: bookmarks (bookmark materi)
    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        material_id INTEGER NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (material_id) REFERENCES materials(id) ON DELETE CASCADE
      )
    ''');

    // Table: reminders (pengingat skrining)
    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id INTEGER NOT NULL,
        reminder_type TEXT NOT NULL,
        target_date TEXT NOT NULL,
        is_notified INTEGER DEFAULT 0,
        is_completed INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (child_id) REFERENCES children(id) ON DELETE CASCADE
      )
    ''');

    // Table: app_info (metadata aplikasi)
    await db.execute('''
      CREATE TABLE app_info (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    // Table: user_profile (NEW! - profil pengguna/pengasuh - opsional)
    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY CHECK(id = 1),
        name TEXT NOT NULL,
        role TEXT NOT NULL CHECK(role IN ('Ibu', 'Ayah', 'Nenek', 'Kakek', 'Pengasuh', 'Nakes')),
        photo_path TEXT,
        location TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Insert default app_info
    await db.insert('app_info', {
      'key': 'version',
      'value': AppInfo.appVersion,
    });
    await db.insert('app_info', {
      'key': 'last_updated',
      'value': DateTime.now().toIso8601String(),
    });
    await db.insert('app_info', {'key': 'first_launch', 'value': '1'});
    await db.insert('app_info', {'key': 'disclaimer_accepted', 'value': '0'});
    await db.insert('app_info', {
      'key': 'user_profile_completed',
      'value': '0',
    });

    // Create indexes for performance
    await db.execute(
      'CREATE INDEX idx_materials_category ON materials(category)',
    );
    await db.execute('CREATE INDEX idx_materials_tags ON materials(tags)');
    await db.execute(
      'CREATE INDEX idx_screening_child ON screening_results(child_id)',
    );
    await db.execute('CREATE INDEX idx_kpsp_age ON kpsp_questions(age_months)');
    await db.execute(
      'CREATE INDEX idx_bookmarks_material ON bookmarks(material_id)',
    );
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migration from v1 to v2: Add user_profile table
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_profile (
          id INTEGER PRIMARY KEY CHECK(id = 1),
          name TEXT NOT NULL,
          role TEXT NOT NULL CHECK(role IN ('Ibu', 'Ayah', 'Nenek', 'Kakek', 'Pengasuh', 'Nakes')),
          photo_path TEXT,
          location TEXT,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      // Add user_profile_completed flag to app_info
      await db.insert('app_info', {
        'key': 'user_profile_completed',
        'value': '0',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Migration v2 -> v3: Add birth_place and identity_number to children
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE children ADD COLUMN birth_place TEXT');
      await db.execute('ALTER TABLE children ADD COLUMN identity_number TEXT');
    }

    // Migration v3 -> v4: Add image column to materials
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE materials ADD COLUMN image TEXT');
    }
  }

  // ==================== CHILDREN OPERATIONS ====================

  /// Insert new child profile
  Future<int> insertChild(Map<String, dynamic> child) async {
    final db = await database;
    return await db.insert('children', child);
  }

  /// Get all children profiles
  Future<List<Map<String, dynamic>>> getAllChildren() async {
    final db = await database;
    return await db.query('children', orderBy: 'created_at DESC');
  }

  /// Get child by ID
  Future<Map<String, dynamic>?> getChildById(int id) async {
    final db = await database;
    final results = await db.query(
      'children',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Update child profile
  Future<int> updateChild(int id, Map<String, dynamic> child) async {
    final db = await database;
    child['updated_at'] = DateTime.now().toIso8601String();
    return await db.update('children', child, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete child profile
  Future<int> deleteChild(int id) async {
    final db = await database;
    return await db.delete('children', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== SCREENING RESULTS OPERATIONS ====================

  /// Insert screening result
  Future<int> insertScreeningResult(Map<String, dynamic> result) async {
    final db = await database;
    return await db.insert('screening_results', result);
  }

  /// Get all screening results for a child
  Future<List<Map<String, dynamic>>> getScreeningResultsByChild(
    int childId,
  ) async {
    final db = await database;
    return await db.query(
      'screening_results',
      where: 'child_id = ?',
      whereArgs: [childId],
      orderBy: 'created_at DESC',
    );
  }

  /// Get screening results by type and child
  Future<List<Map<String, dynamic>>> getScreeningResultsByType(
    int childId,
    String screeningType,
  ) async {
    final db = await database;
    return await db.query(
      'screening_results',
      where: 'child_id = ? AND screening_type = ?',
      whereArgs: [childId, screeningType],
      orderBy: 'created_at DESC',
    );
  }

  /// Delete screening result
  Future<int> deleteScreeningResult(int id) async {
    final db = await database;
    return await db.delete(
      'screening_results',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== MATERIALS OPERATIONS ====================

  /// Insert material (for initial data population)
  Future<int> insertMaterial(Map<String, dynamic> material) async {
    final db = await database;
    return await db.insert('materials', material);
  }

  /// Bulk insert materials
  Future<void> insertMaterialsBulk(List<Map<String, dynamic>> materials) async {
    final db = await database;
    final batch = db.batch();
    for (var material in materials) {
      batch.insert('materials', material);
    }
    await batch.commit(noResult: true);
  }

  /// Get materials by category
  Future<List<Map<String, dynamic>>> getMaterialsByCategory(
    String category,
  ) async {
    final db = await database;
    return await db.query(
      'materials',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'id ASC',
    );
  }

  /// Get materials by subcategory
  Future<List<Map<String, dynamic>>> getMaterialsBySubcategory(
    String category,
    String subcategory,
  ) async {
    final db = await database;
    return await db.query(
      'materials',
      where: 'category = ? AND subcategory = ?',
      whereArgs: [category, subcategory],
      orderBy: 'id ASC',
    );
  }

  /// Search materials by keyword
  Future<List<Map<String, dynamic>>> searchMaterials(String keyword) async {
    final db = await database;
    return await db.query(
      'materials',
      where: 'title LIKE ? OR content LIKE ? OR tags LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%', '%$keyword%'],
      orderBy: 'id ASC',
    );
  }

  /// Get material by ID
  Future<Map<String, dynamic>?> getMaterialById(int id) async {
    final db = await database;
    final results = await db.query(
      'materials',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // ==================== BOOKMARKS OPERATIONS ====================

  /// Add bookmark
  Future<int> addBookmark(int materialId) async {
    final db = await database;
    return await db.insert('bookmarks', {'material_id': materialId});
  }

  /// Remove bookmark
  Future<int> removeBookmark(int materialId) async {
    final db = await database;
    return await db.delete(
      'bookmarks',
      where: 'material_id = ?',
      whereArgs: [materialId],
    );
  }

  /// Check if material is bookmarked
  Future<bool> isBookmarked(int materialId) async {
    final db = await database;
    final results = await db.query(
      'bookmarks',
      where: 'material_id = ?',
      whereArgs: [materialId],
    );
    return results.isNotEmpty;
  }

  /// Get all bookmarked materials
  Future<List<Map<String, dynamic>>> getBookmarkedMaterials() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT m.* FROM materials m
      INNER JOIN bookmarks b ON m.id = b.material_id
      ORDER BY b.created_at DESC
    ''');
  }

  // ==================== KPSP QUESTIONS OPERATIONS ====================

  /// Insert KPSP questions (bulk)
  Future<void> insertKpspQuestionsBulk(
    List<Map<String, dynamic>> questions,
  ) async {
    final db = await database;
    final batch = db.batch();
    for (var question in questions) {
      batch.insert('kpsp_questions', question);
    }
    await batch.commit(noResult: true);
  }

  /// Get KPSP questions by age
  Future<List<Map<String, dynamic>>> getKpspQuestionsByAge(
    int ageMonths,
  ) async {
    final db = await database;
    return await db.query(
      'kpsp_questions',
      where: 'age_months = ?',
      whereArgs: [ageMonths],
      orderBy: 'question_number ASC',
    );
  }

  // ==================== REMINDERS OPERATIONS ====================

  /// Insert reminder
  Future<int> insertReminder(Map<String, dynamic> reminder) async {
    final db = await database;
    return await db.insert('reminders', reminder);
  }

  /// Get active reminders for a child
  Future<List<Map<String, dynamic>>> getActiveReminders(int childId) async {
    final db = await database;
    return await db.query(
      'reminders',
      where: 'child_id = ? AND is_completed = 0',
      whereArgs: [childId],
      orderBy: 'target_date ASC',
    );
  }

  /// Mark reminder as completed
  Future<int> completeReminder(int id) async {
    final db = await database;
    return await db.update(
      'reminders',
      {'is_completed': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete reminder
  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== APP INFO OPERATIONS ====================

  /// Get app info value by key
  Future<String?> getAppInfo(String key) async {
    final db = await database;
    final results = await db.query(
      'app_info',
      where: 'key = ?',
      whereArgs: [key],
    );
    return results.isNotEmpty ? results.first['value'] as String? : null;
  }

  /// Update app info
  Future<int> updateAppInfo(String key, String value) async {
    final db = await database;
    return await db.update(
      'app_info',
      {'value': value},
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  // ==================== USER PROFILE OPERATIONS ====================

  /// Get user profile (returns null if not set)
  Future<UserProfile?> getUserProfile() async {
    final db = await database;
    final maps = await db.query(
      'user_profile',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (maps.isEmpty) return null;
    return UserProfile.fromMap(maps.first);
  }

  /// Save or update user profile
  Future<int> saveUserProfile(UserProfile profile) async {
    final db = await database;

    // Always use id = 1 for single user
    final profileData = profile.toMap();
    profileData['id'] = 1;
    profileData['updated_at'] = DateTime.now().toIso8601String();

    // Insert or replace
    final result = await db.insert(
      'user_profile',
      profileData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Update app_info flag
    await db.insert('app_info', {
      'key': 'user_profile_completed',
      'value': '1',
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    return result;
  }

  /// Update user profile
  Future<int> updateUserProfile(UserProfile profile) async {
    final db = await database;

    final profileData = profile.toMap();
    profileData['updated_at'] = DateTime.now().toIso8601String();

    return await db.update(
      'user_profile',
      profileData,
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  /// Delete user profile
  Future<int> deleteUserProfile() async {
    final db = await database;

    // Delete profile
    final result = await db.delete(
      'user_profile',
      where: 'id = ?',
      whereArgs: [1],
    );

    // Update app_info flag
    await db.insert('app_info', {
      'key': 'user_profile_completed',
      'value': '0',
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    return result;
  }

  /// Check if user profile exists
  Future<bool> hasUserProfile() async {
    final profile = await getUserProfile();
    return profile != null && profile.isComplete;
  }

  /// Get user name for greeting (returns default if not set)
  Future<String> getUserName() async {
    final profile = await getUserProfile();
    return profile?.name ?? 'Bunda';
  }

  /// Get user greeting based on time
  Future<String> getUserGreeting() async {
    final profile = await getUserProfile();
    if (profile != null) {
      return profile.getTimeBasedGreeting();
    }

    // Default greeting
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat pagi, Bunda!';
    if (hour < 15) return 'Selamat siang, Bunda!';
    if (hour < 18) return 'Selamat sore, Bunda!';
    return 'Selamat malam, Bunda!';
  }

  // ==================== UTILITY OPERATIONS ====================

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  /// Delete database (for testing/reset)
  Future<void> deleteDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppInfo.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  /// Get database statistics
  Future<Map<String, int>> getDatabaseStats() async {
    final db = await database;

    final childrenCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM children'),
        ) ??
        0;

    final materialsCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM materials'),
        ) ??
        0;

    final screeningsCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM screening_results'),
        ) ??
        0;

    final bookmarksCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM bookmarks'),
        ) ??
        0;

    final hasProfile =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM user_profile'),
        ) ??
        0;

    return {
      'children': childrenCount,
      'materials': materialsCount,
      'screenings': screeningsCount,
      'bookmarks': bookmarksCount,
      'hasProfile': hasProfile,
    };
  }
}
