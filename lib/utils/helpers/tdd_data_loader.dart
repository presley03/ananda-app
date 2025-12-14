import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/tdd_question.dart';

/// Helper untuk load pertanyaan TDD dari JSON files
/// JSON files: lib/data/json/screening/tdd/tdd_{age_range}.json
class TddDataLoader {
  /// Load pertanyaan TDD untuk rentang usia tertentu
  ///
  /// Age ranges: "<3", "3-6", "6-12", "12-24", "24-36", ">36"
  /// Returns null jika file tidak ditemukan
  static Future<List<TddQuestion>?> loadQuestions(String ageRange) async {
    try {
      // Convert age range ke format filename
      // "<3" → "less_3"
      // "3-6" → "3_6"
      // ">36" → "more_36"
      String filename = _ageRangeToFilename(ageRange);

      final String jsonString = await rootBundle.loadString(
        'lib/data/json/screening/tdd/tdd_$filename.json',
      );

      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList.map((json) => TddQuestion.fromMap(json)).toList();
    } catch (e) {
      print('Error loading TDD questions for age $ageRange: $e');
      return null;
    }
  }

  /// Get list age ranges yang sudah ada datanya
  /// Returns list of available age ranges
  static Future<List<String>> getAvailableAgeRanges() async {
    final List<String> allAgeRanges = [
      '<3',
      '3-6',
      '6-12',
      '12-24',
      '24-36',
      '>36',
    ];

    final List<String> available = [];

    for (String ageRange in allAgeRanges) {
      final questions = await loadQuestions(ageRange);
      if (questions != null && questions.isNotEmpty) {
        available.add(ageRange);
      }
    }

    return available;
  }

  /// Check apakah data untuk rentang usia tertentu tersedia
  static Future<bool> isAgeRangeAvailable(String ageRange) async {
    final questions = await loadQuestions(ageRange);
    return questions != null && questions.isNotEmpty;
  }

  /// Convert age range string ke format filename
  /// Internal helper method
  static String _ageRangeToFilename(String ageRange) {
    // Remove spaces
    String clean = ageRange.replaceAll(' ', '');

    // Convert special characters
    if (clean.startsWith('<')) {
      // "<3" â†' "less_3"
      return 'less_${clean.substring(1)}';
    } else if (clean.startsWith('>')) {
      // ">36" â†' "more_36"
      return 'more_${clean.substring(1)}';
    } else {
      // "3-6" â†' "3_6"
      return clean.replaceAll('-', '_');
    }
  }

  /// Get all TDD questions grouped by age range
  /// Returns Map<ageRange, List<TddQuestion>>
  static Future<Map<String, List<TddQuestion>>> loadAllQuestions() async {
    final Map<String, List<TddQuestion>> allQuestions = {};
    final availableRanges = await getAvailableAgeRanges();

    for (String ageRange in availableRanges) {
      final questions = await loadQuestions(ageRange);
      if (questions != null) {
        allQuestions[ageRange] = questions;
      }
    }

    return allQuestions;
  }

  /// Get total number of questions for a specific age range
  static Future<int> getQuestionCount(String ageRange) async {
    final questions = await loadQuestions(ageRange);
    return questions?.length ?? 0;
  }

  /// Get age range description (untuk display)
  static String getAgeRangeDescription(String ageRange) {
    switch (ageRange) {
      case '<3':
        return 'Kurang dari 3 bulan';
      case '3-6':
        return '3-6 bulan';
      case '6-12':
        return '6-12 bulan';
      case '12-24':
        return '12-24 bulan (1-2 tahun)';
      case '24-36':
        return '24-36 bulan (2-3 tahun)';
      case '>36':
        return 'Lebih dari 36 bulan (>3 tahun)';
      default:
        return ageRange;
    }
  }

  /// Alias untuk getAgeRangeDescription (backward compatibility)
  static String getAgeRangeDisplayName(String ageRange) {
    return getAgeRangeDescription(ageRange);
  }

  /// Check apakah data tersedia untuk age range tertentu
  static Future<bool> isDataAvailable(String ageRange) async {
    final questions = await loadQuestions(ageRange);
    return questions != null && questions.isNotEmpty;
  }
}
