import 'app_strings.dart';
import 'en_strings.dart';
import 'tr_strings.dart';

/// Uygulama genelinde aktif dil yönetimi.
/// Yeni dil eklemek için:
/// 1. `AppStrings` extend eden yeni sınıf oluşturun (ör: `EsStrings`)
/// 2. `_supportedLocales` map'ine ekleyin
/// 3. `setLocale('es')` ile aktif edin
class AppLocale {
  static AppStrings _current = EnStrings();

  static final Map<String, AppStrings> _supportedLocales = {
    'en': EnStrings(),
    'tr': TrStrings(),
  };

  /// Aktif dil string'leri
  static AppStrings get strings => _current;

  /// Dili değiştir
  static void setLocale(String languageCode) {
    _current = _supportedLocales[languageCode] ?? EnStrings();
  }

  /// Desteklenen dil kodları
  static List<String> get supportedLanguageCodes =>
      _supportedLocales.keys.toList();

  /// Aktif dil kodu
  static String get currentLanguageCode {
    for (final entry in _supportedLocales.entries) {
      if (entry.value.runtimeType == _current.runtimeType) {
        return entry.key;
      }
    }
    return 'en';
  }
}
