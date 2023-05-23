import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:lokalise_flutter_sdk/ota/platforms/platform.dart';
import 'package:lokalise_flutter_sdk/ota/service/logger.dart';

class Functions {
  static final _log = getLogger();

  /// Get current locale from Intl library
  static String getCurrentLocale() {
    return Intl.getCurrentLocale();
  }

  /// Json formatter
  static String formatJsonMessage(String jsonMessage) {
    try {
      var decoded = convert.jsonDecode(jsonMessage);
      return convert.jsonEncode(decoded);
    } catch (e) {
      return jsonMessage;
    }
  }

  /// Get device locale
  static String? getDeviceLocale() {
    String? deviceLocale;
    try {
      var platform = Platform();
      deviceLocale = platform.getLocale();
    } catch (e) {
      _log.w('Failed to detect device locale');
    }
    return deviceLocale;
  }
}
