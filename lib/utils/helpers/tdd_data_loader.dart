import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/tdd_question.dart';

/// Helper untuk load pertanyaan TDD dari JSON files
/// JSON files: lib/data/json/tdd_{age_range}.json
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
        'lib/data/json/tdd_$filename.json',
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

  /// Check apakah data tersedia untuk age range tertentu
  static Future<bool> isDataAvailable(String ageRange) async {
    final questions = await loadQuestions(ageRange);
    return questions != null && questions.isNotEmpty;
  }

  /// Convert age range string ke filename format
  /// "<3" → "less_3"
  /// "3-6" → "3_6"
  /// ">36" → "more_36"
  static String _ageRangeToFilename(String ageRange) {
    if (ageRange.startsWith('<')) {
      // "<3" → "less_3"
      return 'less_${ageRange.substring(1)}';
    } else if (ageRange.startsWith('>')) {
      // ">36" → "more_36"
      return 'more_${ageRange.substring(1)}';
    } else {
      // "3-6" → "3_6"
      return ageRange.replaceAll('-', '_');
    }
  }

  /// Convert bulan ke age range
  /// 0-2 bulan → "<3"
  /// 3-5 bulan → "3-6"
  /// dst...
  static String getAgeRangeFromMonths(int months) {
    if (months < 3) {
      return '<3';
    } else if (months >= 3 && months < 6) {
      return '3-6';
    } else if (months >= 6 && months < 12) {
      return '6-12';
    } else if (months >= 12 && months < 24) {
      return '12-24';
    } else if (months >= 24 && months < 36) {
      return '24-36';
    } else {
      return '>36';
    }
  }

  /// Get display name untuk age range
  static String getAgeRangeDisplayName(String ageRange) {
    switch (ageRange) {
      case '<3':
        return 'Kurang dari 3 Bulan';
      case '3-6':
        return '3-6 Bulan';
      case '6-12':
        return '6-12 Bulan';
      case '12-24':
        return '12-24 Bulan';
      case '24-36':
        return '24-36 Bulan';
      case '>36':
        return 'Lebih dari 36 Bulan';
      default:
        return ageRange;
    }
  }
}
