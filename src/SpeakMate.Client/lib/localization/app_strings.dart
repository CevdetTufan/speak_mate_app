/// Uygulamadaki tüm metin string'lerinin abstract tanımı.
/// Yeni dil eklemek için bu sınıfı extend edin.
abstract class AppStrings {
  // Genel
  String get appTitle;

  // Speech Screen - Üst bar
  String get aiIsListening;
  String get appName;

  // Speech Screen - Mikrofon
  String get tapToPause;
  String get tapToSpeak;

  // Speech Screen - Metin alanı
  String get listening;
  String get tapMicToStart;
}
