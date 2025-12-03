/// App Information Constants
/// Metadata dan informasi aplikasi Ananda
class AppInfo {
  // App Identity
  static const String appName = 'Ananda';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Aplikasi monitoring dan edukasi tumbuh kembang anak usia 0-5 tahun';

  // Developer Info
  static const String developerName = 'Tim Ananda';
  static const String developerEmail = 'support@ananda.app';
  static const String releaseYear = '2025';

  // Database Info
  static const String databaseName = 'ananda.db';
  static const int databaseVersion = 1;

  // App Settings Keys (untuk SharedPreferences)
  static const String keyFirstLaunch = 'first_launch';
  static const String keyDisclaimerAccepted = 'disclaimer_accepted';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyReminderTime = 'reminder_time';

  // Default Values
  static const bool defaultNotificationsEnabled = true;
  static const String defaultReminderTime = '09:00'; // Format HH:mm

  // Legal URLs (jika nanti ada web version)
  static const String privacyPolicyUrl = '';
  static const String termsOfServiceUrl = '';
  static const String helpUrl = '';
}
