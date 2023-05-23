// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lokalise_flutter_sdk/ota/data/sdk_ota_data.dart';
import 'package:lokalise_flutter_sdk/ota/model/stored_release_data.dart';
import 'package:lokalise_flutter_sdk/ota/service/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'platform.dart';
import 'dart:convert' as convert;

Platform createPlatform() => BrowserPlatform();

class BrowserPlatform implements Platform {
  static final _log = getLogger();

  @override

  /// Get device locale
  String getLocale() {
    return SdkOtaData.canonicalizedLocale(html.window.navigator.language);
  }

  @override

  /// Get data from storage
  Future<StoredReleaseData?> getStoredReleaseData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var jsonString = prefs.getString('storedReleaseData') ?? "";
      if (jsonString.isEmpty) return null;
      Map<String, dynamic> json = convert.jsonDecode(jsonString);
      return StoredReleaseData.fromJson(json);
    } catch (e) {
      _log.i('Load cache failed: $e');
      throw PlatformException(code: '$e');
    }
  }

  @override

  /// Save data to storage
  Future<void> saveStoredReleaseData(
      StoredReleaseData storedReleaseData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var saveData = jsonEncode(storedReleaseData);
      await prefs.setString('storedReleaseData', saveData);
    } catch (e) {
      _log.i('Save to cache failed: $e');
      throw PlatformException(code: '$e');
    }
  }

  @override

  /// Remove data from cache
  Future<void> removeStoredReleaseData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('storedReleaseData');
    } catch (e) {
      _log.i('Failed to clear cache: $e');
      throw PlatformException(code: '$e');
    }
  }
}
