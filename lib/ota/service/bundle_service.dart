import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:lokalise_flutter_sdk/ota/api/api.dart';
import 'package:lokalise_flutter_sdk/ota/data/sdk_ota_data.dart';
import 'package:lokalise_flutter_sdk/ota/exeptions/api_exception.dart';
import 'package:lokalise_flutter_sdk/ota/exeptions/sdk_exception.dart';
import 'package:lokalise_flutter_sdk/ota/exeptions/update_exception.dart';
import 'package:lokalise_flutter_sdk/ota/model/bundle_archive.dart';
import 'package:lokalise_flutter_sdk/ota/model/label_tr.dart';
import 'package:lokalise_flutter_sdk/ota/model/release_data.dart';
import 'package:lokalise_flutter_sdk/ota/service/bundle_data.dart';
import 'package:lokalise_flutter_sdk/ota/service/logger.dart';
import 'package:lokalise_flutter_sdk/ota/service/sdk_store.dart';

class BundleService {
  static final _log = getLogger();

  /// Get bundle data
  static Future<int> getBundle(String sdkToken, String projectId,
      bool preRelease, int transVersion, int? appVersion) async {
    try {
      BundleArchive bundleDataInfo = await Api.getBundleData(
          sdkToken, projectId, preRelease, transVersion, appVersion!);
      int bundleTransVersion = transVersion;
      if (bundleDataInfo.newRelease == true) {
        // release has been updated
        BundleData bundleData =
            await bundleExtract(bundleDataInfo.bundleArchive);
        bundleTransVersion = bundleDataInfo.transVersion;
        var releaseData =
            ReleaseData(version: bundleTransVersion, data: bundleData.data);
        SdkOtaData.releaseData = releaseData;
        await SdkStore.releaseData(projectId, releaseData);
      }
      return bundleTransVersion;
    } on ApiException {
      rethrow;
    } on UpdateException {
      rethrow;
    } on SdkException {
      rethrow;
    } catch (e) {
      _log.i("BundleService getBundle - $e");
      rethrow;
    }
  }

  /// Extract bundle
  static Future<BundleData> bundleExtract(Archive bundleArchive) async {
    if (bundleArchive.isEmpty) {
      throw ApiException(
          "BundleService bundleExtract - failed to extracted BundleData (wrong archive)");
    }
    try {
      BundleData bundleData = BundleData(data: {});
      for (int i = 1; i < bundleArchive.length; i++) {
        String? locale;
        ArchiveFile jsonArchive = bundleArchive.files[i];
        var localeStart = jsonArchive.toString().substring(7);
        locale = localeStart.substring(0, localeStart.length - 5);
        final dataFile = utf8.decode(jsonArchive.content);
        final Map<String, dynamic> jsonDecoded = await json.decode(dataFile);
        Map<String, LabelTr> stringLabelMap = {};
        jsonDecoded
            .forEach((k, v) => {stringLabelMap[k] = LabelTr(key: k, value: v)});
        bundleData.data[locale] = stringLabelMap;
        _log.d(
            "Value for key 'pageHomeWelcomeMessage' in $locale: ${jsonDecoded["pageHomeWelcomeMessage"]}");
      }
      return bundleData;
    } catch (e) {
      _log.i("BundleService bundleExtract - $e");
      throw ApiException("BundleService bundleExtract - $e");
    }
  }

  /// Get data cache by Project ID
  static Future<ReleaseData?> getStoredReleaseData(String projectId) {
    return SdkStore.getReleaseData(projectId);
  }
}
