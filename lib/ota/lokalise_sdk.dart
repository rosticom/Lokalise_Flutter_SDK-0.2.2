// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';
import 'package:lokalise_flutter_sdk/ota/demo/globals.dart';
import 'package:lokalise_flutter_sdk/ota/data/sdk_ota_data.dart';
import 'package:lokalise_flutter_sdk/ota/exeptions/api_exception.dart';
import 'package:lokalise_flutter_sdk/ota/exeptions/sdk_exception.dart';
import 'package:lokalise_flutter_sdk/ota/exeptions/update_exception.dart';
import 'package:lokalise_flutter_sdk/ota/model/translation_result.dart';
import 'package:lokalise_flutter_sdk/ota/service/bundle_service.dart';
import 'package:lokalise_flutter_sdk/ota/service/functions.dart';
import 'package:lokalise_flutter_sdk/ota/service/logger.dart';
import 'package:lokalise_flutter_sdk/ota/service/proxy.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Lokalise {
  static final _log = getLogger();
  static String? _sdkToken;
  static String? _projectId;
  static bool? _preRelease = false;
  static int _appVersion = 0;
  static String deviceLocale = "en";

  Lokalise._();

// Globals, _log.d(), this part for demonstration
  static void initDemo(int demoApi3) {
    init("SDK Token", "Project ID");
    Globals.isProduction = false;
    String testProjectId = "75026070604728d9a006e4.52983736";
    switch (demoApi3) {
      case 0: // Get wrong params (400: Invalid parameters)
        Globals.testUrl = "${Globals.testDomain}/wrong_project/formats/json";
        break;
      case 1: // Get wrong project (404: Project not found)
        Globals.testUrl =
            "${Globals.testDomain}/wrong_project/formats/json?appVersion=10&transVersion=4&prerelease=1";
        break;
      case 2: // Get wrong bundle (404: Bundle not found)
        Globals.testUrl =
            "${Globals.testDomain}/$testProjectId/formats/yaml?appVersion=10&transVersion=4&prerelease=1";
        break;
      case 3: // Get prerelease bundle ()
        Globals.testUrl =
            "${Globals.testDomain}/$testProjectId/formats/json?appVersion=10&transVersion=44&prerelease=1";
        break;
      case 4: // Get prod bundle
        Globals.testUrl =
            "${Globals.testDomain}/$testProjectId/formats/json?appVersion=50&transVersion=4";
        break;
      case 5: // Get bundle freeze 1 (appVersions between 1 and 15)
        Globals.testUrl =
            "${Globals.testDomain}/$testProjectId/formats/json?appVersion=10&transVersion=4";
        break;
      case 6: // Get bundle freeze 2 (appVersions between 16 and 40)
        Globals.testUrl =
            "${Globals.testDomain}/$testProjectId/formats/json?appVersion=16&transVersion=4";
        break;
      case 7: // Get nothing to update
        Globals.testUrl =
            "${Globals.testDomain}/$testProjectId/formats/json?appVersion=16&transVersion=6";
        break;
      default: // Default (any another case): get prod bundle
        Globals.testUrl =
            "${Globals.testDomain}/$testProjectId/formats/json?appVersion=50&transVersion=4";
    }
  }
// Globals, _log.d(), this part for demonstration end

  /// Initialization flutter_ota_sdk with SDK Token and Project ID
  static void init(String sdkToken, String projectId) {
    _sdkToken = sdkToken;
    _projectId = projectId;
    messageLookup = MessageLookupProxy.from(messageLookup);
  }

  /// To use pre release call this function (optionaly)
  static void preRelease(bool preRelease) {
    _preRelease = preRelease || false;
  }

  /// call this to set version of translate (optionaly)
  static void setVersion(version) {
    _appVersion = version;
  }

  /// main function for update translates (call after initialization and intl delegates)
  static Future<UpdateResult> update() async {
    if (_sdkToken!.isEmpty) {
      String exeptionMessage =
          'Token has not been provided during Lokalise initialization';
      _log.w(exeptionMessage);
      throw SdkException(exeptionMessage);
    }
    if (_projectId!.isEmpty) {
      String exeptionMessage =
          'Project ID has not been provided during Lokalise initialization';
      _log.w(exeptionMessage);
      throw SdkException(exeptionMessage);
    }
    if (!SdkOtaData.hasReleaseData) {
      SdkOtaData.releaseData =
          await BundleService.getStoredReleaseData(_projectId!);
    }
    if (_appVersion == 0) {
      final info = await PackageInfo.fromPlatform();
      _log.d("Build number: ${info.buildNumber}");
      _log.d("App version: ${info.version}");
      _appVersion = int.tryParse(info.buildNumber) ?? 0;
    }
    _log.d("App version as is build number (integer): $_appVersion");
    deviceLocale = Functions.getDeviceLocale()!;
    _log.d("Device locale: $deviceLocale");
    int? transVersion = SdkOtaData.releaseVersion;
    transVersion ??= 0;
    if (!Globals.isProduction) transVersion = 0;
    _log.d("Storage translation version: $transVersion");
    _log.d("_sdkToken: $_sdkToken");
    _log.d("_projectId: $_projectId");
    try {
      int newReleaseVersion = await BundleService.getBundle(
          _sdkToken!, _projectId!, _preRelease!, transVersion, _appVersion);
      _log.d("New bundle translate version: $newReleaseVersion");
      return UpdateResult(transVersion, newReleaseVersion);
    } on ApiException {
      rethrow;
    } on UpdateException {
      rethrow;
    } on SdkException {
      rethrow;
    } catch (e) {
      _log.e("Lokalise.update: $e");
      rethrow;
    }
  }

  /// Save cache to local storage (all languages)
  static void setMetadata(Map<String, List<String>> otadata) {
    SdkOtaData.otadata = otadata;
  }

  /// Check if current device has data cache
  static bool hasMetadata() {
    return SdkOtaData.otadata != null;
  }
}
