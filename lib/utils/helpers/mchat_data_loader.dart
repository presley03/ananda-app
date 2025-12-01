import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/mchat_question.dart';

/// Helper untuk load pertanyaan M-CHAT-R dari JSON file
/// M-CHAT-R: 20 pertanyaan untuk anak usia 16-30 bulan
class MchatDataLoader {
  /// Load semua pertanyaan M-CHAT-R
  ///
  /// Returns null jika file tidak ditemukan
  static Future<List<MchatQuestion>?> loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'lib/data/json/mchat_questions.json',
      );

      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList.map((json) => MchatQuestion.fromMap(json)).toList();
    } catch (e) {
      print('Error loading M-CHAT-R questions: $e');
      return null;
    }
  }

  /// Check apakah data tersedia
  static Future<bool> isDataAvailable() async {
    final questions = await loadQuestions();
    return questions != null && questions.isNotEmpty;
  }

  /// Get age range untuk M-CHAT-R
  /// M-CHAT-R digunakan untuk anak usia 16-30 bulan
  static String getAgeRangeDisplay() {
    return '16-30 Bulan';
  }

  /// Get age range dalam bulan
  static List<int> getAgeRangeMonths() {
    return [16, 30]; // [min, max]
  }

  /// Check apakah usia anak sesuai untuk M-CHAT-R
  static bool isAgeAppropriate(int ageInMonths) {
    return ageInMonths >= 16 && ageInMonths <= 30;
  }
}
