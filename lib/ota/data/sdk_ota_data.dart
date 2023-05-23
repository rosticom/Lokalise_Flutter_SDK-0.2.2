import 'package:intl/intl.dart';
import 'package:lokalise_flutter_sdk/ota/model/label_tr.dart';
import 'package:lokalise_flutter_sdk/ota/model/release_data.dart';

class SdkOtaData {
  static Map<String, List<String>>? otadata;
  static ReleaseData? releaseData;

  SdkOtaData._();

  /// Get version of translate
  static int? get releaseVersion => releaseData?.version;

  /// If data present in cache
  static bool get hasReleaseData => releaseData != null;

  /// Intl function
  static String canonicalizedLocale(String locale) {
    return Intl.canonicalizedLocale(locale);
  }

  /// Get data
  static Map<String, LabelTr>? getData(String locale) =>
      releaseData?.data != null ? releaseData!.data[locale] : null;

  /// Get args
  static List<String>? getOrigArgs(String? label) =>
      otadata != null ? otadata![label] : null;
}
