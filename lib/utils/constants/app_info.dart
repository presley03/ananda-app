/// File: app_info.dart
/// Path: lib/utils/constants/app_info.dart
/// Description: App metadata constants untuk Ananda app

class AppInfo {
  // Prevent instantiation
  AppInfo._();

  // ============================================
  // APP IDENTITY
  // ============================================

  /// Application name
  static const String appName = 'Ananda';

  /// Application tagline
  static const String tagline = 'Pantau Tumbuh Kembang Si Kecil dengan Mudah';

  /// Application description
  static const String appDescription =
      'Aplikasi untuk memantau tumbuh kembang anak usia 0-5 tahun dengan fitur skrining KPSP, status gizi, TDD, M-CHAT-R, dan materi edukatif berbasis pedoman Kemenkes & WHO';

  /// Package name (Android)
  static const String packageName = 'com.ananda.tumbuhkembang';

  /// Application ID (for internal use)
  static const String appId = 'ananda_app';

  // ============================================
  // VERSION INFO
  // ============================================

  /// Current version number (semantic versioning)
  static const String appVersion = '1.0.0';

  /// Version code (for Android build number)
  static const int versionCode = 1;

  /// Build number
  static const String buildNumber = '1';

  /// Release date
  static const String releaseDate = '2025-12-14';

  /// Release year
  static const String releaseYear = '2025';

  /// Last update date
  static const String lastUpdate = '2025-12-14';

  // ============================================
  // DATABASE INFO
  // ============================================

  /// Database name
  static const String databaseName = 'ananda.db';

  /// Database version (increment saat schema changes)
  /// v1: Initial schema
  /// v2: Added user_profile table
  static const int databaseVersion = 2; // UPDATED!

  // ============================================
  // SUPPORT & CONTACT
  // ============================================

  /// Support email
  static const String supportEmail = 'support@example.com';

  /// Website URL
  static const String websiteUrl = 'https://example.com';

  /// Privacy policy URL (jika ada web version)
  static const String privacyPolicyUrl = 'https://example.com/privacy';

  /// Terms of use URL (jika ada web version)
  static const String termsOfUseUrl = 'https://example.com/terms';

  /// Instagram handle
  static const String instagram = '@ananda.app';

  /// Facebook page (optional)
  static const String facebook = '';

  /// Twitter handle (optional)
  static const String twitter = '';

  // ============================================
  // DEVELOPER INFO
  // ============================================

  /// Developer name
  static const String developerName = '[Nama Tim Developer]';

  /// Developer website
  static const String developerWebsite = 'https://example.com';

  /// Developer email
  static const String developerEmail = 'dev@example.com';

  /// Organization/Institution
  static const String organization = '[Nama Institusi/Lembaga]';

  // ============================================
  // LEGAL
  // ============================================

  /// Copyright text
  static const String copyright = '© 2025 $organization. All Rights Reserved.';

  /// License type
  static const String license = 'Proprietary';

  // ============================================
  // FEATURE FLAGS
  // ============================================

  /// Enable/disable features for testing or phased rollout

  /// Enable dark mode (future feature)
  static const bool enableDarkMode = false;

  /// Enable export to PDF (future feature)
  static const bool enableExportPDF = false;

  /// Enable sharing functionality (future feature)
  static const bool enableSharing = false;

  /// Enable analytics (future feature)
  static const bool enableAnalytics = false;

  /// Enable cloud sync (future feature)
  static const bool enableCloudSync = false;

  /// Show debug info in UI
  static const bool showDebugInfo = false;

  // ============================================
  // NOTIFICATION CHANNELS
  // ============================================

  /// Notification channel ID for reminders
  static const String notificationChannelId = 'kpsp_reminder';

  /// Notification channel name
  static const String notificationChannelName = 'KPSP Reminder';

  /// Notification channel description
  static const String notificationChannelDesc =
      'Pengingat jadwal skrining KPSP';

  // ============================================
  // APP SETTINGS KEYS (SharedPreferences)
  // ============================================

  /// Key for first launch flag
  static const String keyFirstLaunch = 'first_launch';

  /// Key for onboarding shown flag
  static const String keyOnboardingShown = 'onboarding_shown';

  /// Key for disclaimer accepted flag
  static const String keyDisclaimerAccepted = 'disclaimer_accepted';

  /// Key for notification enabled flag
  static const String keyNotificationEnabled = 'notification_enabled';

  /// Key for last selected child ID
  static const String keyLastSelectedChildId = 'last_selected_child_id';

  // ============================================
  // KPSP SCHEDULE (in months)
  // ============================================

  /// Jadwal skrining KPSP sesuai pedoman Kemenkes
  static const List<int> kpspSchedule = [
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

  /// Get KPSP schedule as readable string
  static String getKpspScheduleString() {
    return kpspSchedule.map((m) => '$m bulan').join(', ');
  }

  // ============================================
  // AGE CATEGORIES
  // ============================================

  /// Age category codes
  static const String category01 = '0-1';
  static const String category12 = '1-2';
  static const String category25 = '2-5';

  /// Age category names
  static const Map<String, String> categoryNames = {
    category01: '0-1 Tahun',
    category12: '1-2 Tahun',
    category25: '2-5 Tahun',
  };

  /// Get category name by code
  static String getCategoryName(String code) {
    return categoryNames[code] ?? 'Unknown';
  }

  // ============================================
  // SCREENING TYPES
  // ============================================

  static const String screeningKPSP = 'KPSP';
  static const String screeningGizi = 'GIZI';
  static const String screeningTDD = 'TDD';
  static const String screeningMCHAT = 'MCHAT';

  /// Screening type full names
  static const Map<String, String> screeningNames = {
    screeningKPSP: 'Kuesioner Pra Skrining Perkembangan',
    screeningGizi: 'Status Gizi',
    screeningTDD: 'Tes Daya Dengar',
    screeningMCHAT: 'M-CHAT-R (Skrining Autisme)',
  };

  /// Get screening name by type
  static String getScreeningName(String type) {
    return screeningNames[type] ?? 'Unknown';
  }

  // ============================================
  // MATERIAL SUBCATEGORIES
  // ============================================

  static const String subcategoryPertumbuhan = 'Pertumbuhan';
  static const String subcategoryPerkembangan = 'Perkembangan';
  static const String subcategoryNutrisi = 'Nutrisi & MP-ASI';
  static const String subcategoryStimulasi = 'Stimulasi';
  static const String subcategoryPerawatan = 'Perawatan';

  /// Material subcategories list
  static const List<String> materialSubcategories = [
    subcategoryPertumbuhan,
    subcategoryPerkembangan,
    subcategoryNutrisi,
    subcategoryStimulasi,
    subcategoryPerawatan,
  ];

  // ============================================
  // GENDER
  // ============================================

  static const String genderMale = 'L';
  static const String genderFemale = 'P';

  /// Gender labels
  static const Map<String, String> genderLabels = {
    genderMale: 'Laki-laki',
    genderFemale: 'Perempuan',
  };

  /// Get gender label
  static String getGenderLabel(String code) {
    return genderLabels[code] ?? 'Unknown';
  }

  // ============================================
  // REMINDER SETTINGS
  // ============================================

  /// Days before target date to send reminder
  static const int reminderDaysBefore = 3;

  /// Reminder notification time (hour)
  static const int reminderHour = 9;

  /// Reminder notification time (minute)
  static const int reminderMinute = 0;

  // ============================================
  // UI CONSTANTS
  // ============================================

  /// Default page padding
  static const double pagePadding = 16.0;

  /// Default card elevation
  static const double cardElevation = 4.0;

  /// Default border radius
  static const double borderRadius = 16.0;

  /// Bottom navigation height
  static const double bottomNavHeight = 60.0;

  /// Search bar height
  static const double searchBarHeight = 50.0;

  // ============================================
  // VALIDATION CONSTANTS
  // ============================================

  /// Min name length
  static const int minNameLength = 2;

  /// Max name length
  static const int maxNameLength = 50;

  /// Min weight (kg)
  static const double minWeight = 1.0;

  /// Max weight (kg)
  static const double maxWeight = 100.0;

  /// Min height (cm)
  static const double minHeight = 30.0;

  /// Max height (cm)
  static const double maxHeight = 200.0;

  /// Min age (months)
  static const int minAge = 0;

  /// Max age (months)
  static const int maxAge = 72;

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Get full app info string
  static String getAppInfoString() {
    return '$appName v$appVersion ($buildNumber)';
  }

  /// Get copyright text with year
  static String getCopyrightText() {
    final year = DateTime.now().year;
    return '© $year $organization. All Rights Reserved.';
  }

  /// Check if feature is enabled
  static bool isFeatureEnabled(String feature) {
    switch (feature) {
      case 'dark_mode':
        return enableDarkMode;
      case 'export_pdf':
        return enableExportPDF;
      case 'sharing':
        return enableSharing;
      case 'analytics':
        return enableAnalytics;
      case 'cloud_sync':
        return enableCloudSync;
      default:
        return false;
    }
  }
}
