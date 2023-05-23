import 'package:flutter/services.dart';
import 'package:lokalise_flutter_sdk/ota/model/release_data.dart';
import 'package:lokalise_flutter_sdk/ota/model/stored_release_data.dart';
import 'package:lokalise_flutter_sdk/ota/platforms/platform.dart';
import 'package:lokalise_flutter_sdk/ota/service/logger.dart';

class SdkStore {
  static final _log = getLogger();

  SdkStore._();

  /// Save data to storage for all platforms
  static Future<void> releaseData(
      String projectId, ReleaseData releaseData) async {
    try {
      var platform = Platform();
      var storedReleaseData = StoredReleaseData(projectId, releaseData);
      await platform.saveStoredReleaseData(storedReleaseData);
      _log.d("Data saved to storage");
    } on PlatformException {
      return;
    } catch (e) {
      _log.w('Failed to cache translations.', e);
    }
  }

  /// Remove data from storage
  static Future<void> removeStoredReleaseData() async {
    try {
      var platform = Platform();
      await platform.removeStoredReleaseData();
      _log.d("The cache has been cleared");
    } on PlatformException {
      return;
    } catch (e) {
      _log.w('Failed to clear cached translations.', e);
    }
  }

  /// Get data from storage by Project ID
  static Future<ReleaseData?> getReleaseData(String projectId) async {
    ReleaseData? releaseData;
    try {
      var platform = Platform();
      var storedData = await platform.getStoredReleaseData();
      _log.d("Data has been loaded from storage");
      if (storedData == null) return null;
      if (storedData.projectId != projectId) {
        await platform.removeStoredReleaseData();
        return null;
      }
      releaseData = storedData.releaseData;
    } on PlatformException {
      _log.d('check platform ');
    } catch (e) {
      _log.w('Failed to load cached translations.', e);
    }
    return releaseData;
  }
}
