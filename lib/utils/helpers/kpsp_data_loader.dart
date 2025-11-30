import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/kpsp_question.dart';

/// KPSP Data Loader
/// Helper untuk load pertanyaan KPSP dari file JSON
class KpspDataLoader {
  /// Load KPSP questions untuk umur tertentu dari JSON file
  ///
  /// Parameter:
  /// - ageMonths: Umur dalam bulan (3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72)
  ///
  /// Returns: List KpspQuestion atau null jika file tidak ada
  static Future<List<KpspQuestion>?> loadQuestions(int ageMonths) async {
    try {
      // Load JSON file dari assets
      final String jsonString = await rootBundle.loadString(
        'lib/data/json/kpsp_${ageMonths}_months.json',
      );

      // Parse JSON
      final List<dynamic> jsonData = json.decode(jsonString);

      // Convert ke List KpspQuestion
      final List<KpspQuestion> questions =
          jsonData.map((json) => KpspQuestion.fromMap(json)).toList();

      return questions;
    } catch (e) {
      // File tidak ditemukan atau error parsing
      // ignore: avoid_print
      print('Error loading KPSP data for $ageMonths months: $e');
      return null;
    }
  }

  /// Get all available ages yang sudah ada datanya
  ///
  /// Returns: List int umur dalam bulan
  static Future<List<int>> getAvailableAges() async {
    final List<int> allAges = [
      3,
      6,
      9,
      12,
      15,
      18,
      21,
      24,
      30,
      36,
      42,
      48,
      54,
      60,
      66,
      72,
    ];

    final List<int> availableAges = [];

    // Check setiap umur apakah ada file-nya
    for (int age in allAges) {
      try {
        await rootBundle.loadString('lib/data/json/kpsp_${age}_months.json');
        availableAges.add(age);
      } catch (e) {
        // File tidak ada, skip
      }
    }

    return availableAges;
  }

  /// Check apakah data untuk umur tertentu tersedia
  ///
  /// Parameter:
  /// - ageMonths: Umur dalam bulan
  ///
  /// Returns: true jika tersedia, false jika tidak
  static Future<bool> isDataAvailable(int ageMonths) async {
    try {
      await rootBundle.loadString(
        'lib/data/json/kpsp_${ageMonths}_months.json',
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
