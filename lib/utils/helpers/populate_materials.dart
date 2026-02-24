// File: populate_materials.dart
// Path: lib/utils/helpers/populate_materials.dart
// Description: Helper untuk populate materials database dengan data dari JSON files
//
// Compatible dengan DatabaseService yang ada
// Data source: JSON files di lib/data/json/materials/

import 'dart:convert';
import 'package:flutter/services.dart';
import '../../services/database_service.dart';

class PopulateMaterials {
  final DatabaseService _dbService = DatabaseService();

  /// Populate database dengan materials data dari JSON files.
  /// Auto-check: hanya mengisi jika database masih kosong.
  Future<void> populateAll() async {
    final stats = await _dbService.getDatabaseStats();
    final count = stats['materials'] ?? 0;
    if (count > 0) return;

    final allMaterials = await _loadAllMaterialsFromJson();
    if (allMaterials.isEmpty) return;

    await _dbService.insertMaterialsBulk(allMaterials);
  }

  /// Hapus semua data lama lalu isi ulang dari JSON.
  Future<void> clearAndRepopulate() async {
    final db = await _dbService.database;
    await db.delete('bookmarks');
    await db.delete('materials');

    final allMaterials = await _loadAllMaterialsFromJson();
    if (allMaterials.isEmpty) return;

    await _dbService.insertMaterialsBulk(allMaterials);
  }

  /// Load semua materi dari JSON files.
  Future<List<Map<String, dynamic>>> _loadAllMaterialsFromJson() async {
    final List<Map<String, dynamic>> allMaterials = [];

    final List<String> jsonPaths = [
      // 0-1 Tahun
      'lib/data/json/materials/0-1/0-1_imunisasi.json',
      'lib/data/json/materials/0-1/0-1_mpasi.json',
      'lib/data/json/materials/0-1/0-1_nutrisi.json',
      'lib/data/json/materials/0-1/0-1_penyakit.json',
      'lib/data/json/materials/0-1/0-1_perawatan.json',
      'lib/data/json/materials/0-1/0-1_perkembangan.json',
      'lib/data/json/materials/0-1/0-1_pertumbuhan.json',
      // 1-2 Tahun
      'lib/data/json/materials/1-2/1-2_nutrisi.json',
      'lib/data/json/materials/1-2/1-2_penyakit.json',
      'lib/data/json/materials/1-2/1-2_perawatan.json',
      'lib/data/json/materials/1-2/1-2_perkembangan.json',
      'lib/data/json/materials/1-2/1-2_permainan.json',
      'lib/data/json/materials/1-2/1-2_pertumbuhan.json',
      'lib/data/json/materials/1-2/1-2_stimulasi.json',
      // 2-5 Tahun
      'lib/data/json/materials/2-5/2-5_nutrisi.json',
      'lib/data/json/materials/2-5/2-5_pertumbuhan.json',
      'lib/data/json/materials/2-5/2-5_perkembangan.json',
      'lib/data/json/materials/2-5/2-5_stimulasi.json',
      'lib/data/json/materials/2-5/2-5_perawatan.json',
      'lib/data/json/materials/2-5/2-5_pencegahan.json',
      'lib/data/json/materials/2-5/2-5_penyakit.json',
      'lib/data/json/materials/2-5/2-5_permainan.json',
    ];

    for (final path in jsonPaths) {
      try {
        final String jsonString = await rootBundle.loadString(path);
        final List<dynamic> jsonData = json.decode(jsonString);
        for (final item in jsonData) {
          if (item is Map<String, dynamic>) {
            allMaterials.add(item);
          }
        }
      } catch (_) {
        // Lewati file yang tidak ditemukan atau gagal di-parse
      }
    }

    return allMaterials;
  }
}
