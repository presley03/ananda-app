import '../models/kpsp_question.dart';

/// KPSP Questions Data for 3 Months
/// Berisi 10 pertanyaan KPSP untuk anak usia 3 bulan
class KpspQuestions3Months {
  /// Get all 10 questions for 3 months old
  static List<KpspQuestion> getQuestions() {
    return [
      KpspQuestion(
        ageMonths: 3,
        questionNumber: 1,
        questionText: 'Pada waktu bayi telentang, apakah masing-masing lengannya bergerak dengan mudah?',
        aspect: 'Motorik Kasar',
      ),
      KpspQuestion(
        ageMonths: 3,
        questionNumber: 2,
        questionText: 'Pada waktu bayi telentang, apakah masing-masing tungkainya bergerak dengan mudah?',
        aspect: 'Motorik Kasar',
      ),
      KpspQuestion(
        ageMonths: 3,
        questionNumber: 3,
        questionText: 'Ketika Anda mengajak bayi berbicara dan bermain, apakah ia tersenyum?',
        aspect: 'Sosialisasi & Kemandirian',
      ),
      KpspQuestion(
        ageMonths: 3,
        questionNumber: 4,
        questionText: 'Apakah bayi dapat melihat anda dengan seksama?',
        aspect: 'Sosialisasi & Kemandirian',
      ),
      KpspQuestion(
        ageMonths: 3,
        questionNumber: 5,
        questionText: 'Apakah bayi mengeluarkan suara-suara lain (ngoceh), disamping menangis?',
        aspect: 'Bicara & Bahasa',
      ),
      KpspQuestion(
        ageMonths: 3,
        questionNumber: 6,
        questionText: 'Pada waktu anda memegang kedua tangannya, lalu diangkat perlahan-lahan ke posisi duduk, apakah bayi berusaha mengangkat kepalanya?',
        aspect: 'Motorik Kasar',
      ),
      KpspQuestion(
        ageMonths: 3,
        questionNumber: 7,
        questionText: 'Dapatkah bayi mempertahankan kepala dalam posisi tegak dan stabil?',
        aspect: 'Motorik Kasar',
      ),
      KpspQuestion(
        ageMonths: 3,
        questionNumber: 8,
        questionText: 'Apakah bayi dapat menahan kepalanya dengan mantap ketika ditegakkan?',
        aspect: 'Motorik Kasar',
      ),
      KpspQuestion(
        ageMonths: 3,
        questionNumber: 9,
        questionText: 'Jika anda menggerakkan sesuatu didepan wajah bayi dari satu sisi ke sisi lain, dapatkah ia mengikuti gerakan benda tersebut?',
        aspect: 'Motorik Halus',
      ),
      KpspQuestion(
        ageMonths: 3,
        questionNumber: 10,
        questionText: 'Apakah bayi menatap wajah anda ketika anda mengajaknya berbicara atau tersenyum kepadanya?',
        aspect: 'Sosialisasi & Kemandirian',
      ),
    ];
  }

  /// Get questions as Map for database insertion
  static List<Map<String, dynamic>> getQuestionsAsMap() {
    return getQuestions().map((q) => q.toMap()).toList();
  }
}
