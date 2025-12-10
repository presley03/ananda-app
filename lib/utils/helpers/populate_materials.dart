library;

/// File: populate_materials.dart
/// Path: lib/utils/helpers/populate_materials.dart
/// Description: Helper untuk populate materials database dengan data dari JSON files
///
/// Compatible dengan DatabaseService yang ada
/// Data source: JSON files di lib/data/json/materials/
///
/// Updated: Load dari JSON files (76 entries total)

import 'dart:convert';
import 'package:flutter/services.dart';
import '../../services/database_service.dart';

class PopulateMaterials {
  final DatabaseService _dbService = DatabaseService();

  /// Populate database dengan materials data dari JSON files
  /// Auto-check if already populated
  Future<void> populateAll() async {
    print('📄 Starting materials population from JSON files...');

    // Check if already populated using getDatabaseStats
    final stats = await _dbService.getDatabaseStats();
    final count = stats['materials'] ?? 0;

    if (count > 0) {
      print('⚠️ Database already has $count materials. Skipping population.');
      print('   Call clearAndRepopulate() to force repopulation.');
      return;
    }

    // Load all materials from JSON files
    final allMaterials = await _loadAllMaterialsFromJson();

    if (allMaterials.isEmpty) {
      print('❌ No materials loaded from JSON files!');
      return;
    }

    print('📦 Loaded ${allMaterials.length} materials from JSON files');

    // Insert all materials using bulk insert
    await _dbService.insertMaterialsBulk(allMaterials);

    final newStats = await _dbService.getDatabaseStats();
    final newCount = newStats['materials'] ?? 0;
    print('✅ Population complete! Total materials: $newCount');
  }

  /// Clear existing data and repopulate
  Future<void> clearAndRepopulate() async {
    print('🔄 Clearing existing materials...');

    // Delete all bookmarks first (foreign key constraint)
    final db = await _dbService.database;
    await db.delete('bookmarks');
    await db.delete('materials');

    print('🔄 Populating fresh materials from JSON files...');

    // Load all materials from JSON files
    final allMaterials = await _loadAllMaterialsFromJson();

    if (allMaterials.isEmpty) {
      print('❌ No materials loaded from JSON files!');
      return;
    }

    print('📦 Loaded ${allMaterials.length} materials from JSON files');

    // Insert all materials
    await _dbService.insertMaterialsBulk(allMaterials);

    final stats = await _dbService.getDatabaseStats();
    final count = stats['materials'] ?? 0;
    print('✅ Repopulation complete! Total materials: $count');
  }

  /// Load all materials from JSON files
  /// Reads from lib/data/json/materials/{category}/{files}.json
  Future<List<Map<String, dynamic>>> _loadAllMaterialsFromJson() async {
    final List<Map<String, dynamic>> allMaterials = [];

    // Define all JSON file paths
    final List<String> jsonPaths = [
      // 0-1 Tahun (7 files, 28 entries)
      'lib/data/json/materials/0-1/0-1_imunisasi.json',
      'lib/data/json/materials/0-1/0-1_mpasi.json',
      'lib/data/json/materials/0-1/0-1_nutrisi.json',
      'lib/data/json/materials/0-1/0-1_penyakit.json',
      'lib/data/json/materials/0-1/0-1_perawatan.json',
      'lib/data/json/materials/0-1/0-1_perkembangan.json',
      'lib/data/json/materials/0-1/0-1_pertumbuhan.json',

      // 1-2 Tahun (7 files, 18 entries)
      'lib/data/json/materials/1-2/1-2_nutrisi.json',
      'lib/data/json/materials/1-2/1-2_penyakit.json',
      'lib/data/json/materials/1-2/1-2_perawatan.json',
      'lib/data/json/materials/1-2/1-2_perkembangan.json',
      'lib/data/json/materials/1-2/1-2_permainan.json',
      'lib/data/json/materials/1-2/1-2_pertumbuhan.json',
      'lib/data/json/materials/1-2/1-2_stimulasi.json',

      // 2-5 Tahun (8 files, 30 entries)
      'lib/data/json/materials/2-5/2-5_nutrisi.json',
      'lib/data/json/materials/2-5/2-5_pertumbuhan.json',
      'lib/data/json/materials/2-5/2-5_perkembangan.json',
      'lib/data/json/materials/2-5/2-5_stimulasi.json',
      'lib/data/json/materials/2-5/2-5_perawatan.json',
      'lib/data/json/materials/2-5/2-5_pencegahan.json',
      'lib/data/json/materials/2-5/2-5_penyakit.json',
      'lib/data/json/materials/2-5/2-5_permainan.json',
    ];

    // Load each JSON file
    for (final path in jsonPaths) {
      try {
        final String jsonString = await rootBundle.loadString(path);
        final List<dynamic> jsonData = json.decode(jsonString);

        // Convert to Map and add to allMaterials
        for (final item in jsonData) {
          if (item is Map<String, dynamic>) {
            allMaterials.add(item);
          }
        }

        print(
          '✓ Loaded ${jsonData.length} entries from ${path.split('/').last}',
        );
      } catch (e) {
        print('❌ Error loading $path: $e');
      }
    }

    return allMaterials;
  }
}
