import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:lokalise_flutter_sdk/ota/demo/globals.dart';
import 'package:lokalise_flutter_sdk/ota/api/downloader.dart';
import 'package:lokalise_flutter_sdk/ota/exeptions/api_exception.dart';
import 'package:lokalise_flutter_sdk/ota/exeptions/sdk_exception.dart';
import 'package:lokalise_flutter_sdk/ota/exeptions/update_exception.dart';
import 'package:lokalise_flutter_sdk/ota/model/bundle_archive.dart';
import 'package:lokalise_flutter_sdk/ota/model/bundle_info.dart';
import 'package:lokalise_flutter_sdk/ota/service/functions.dart';
import 'package:lokalise_flutter_sdk/ota/service/logger.dart';
import 'package:lokalise_flutter_sdk/ota/service/sdk_store.dart';

class Api {
  static final _log = getLogger();
  static const String domain = 'https://api.lokalise.com';
  static Uri? uri;
  static String preReleaseString = '';

  Api._();

  /// Request to Lokalise server for bundle info and data
  static Future<BundleArchive> getBundleData(String sdkToken, String projectId,
      bool preRelease, int trVersion, int appVersion) async {
    try {
      if (preRelease) preReleaseString = '&prerelease=1';
      _log.d('Request for updated translations bundle info...');
      String url =
          '$domain/v3/internal/projects/$projectId/formats/json?appVersion=$appVersion&transVersion=$trVersion$preReleaseString';
      if (!Globals.isProduction) url = Globals.testUrl;
      uri = Uri.parse(url);
      Map<String, String> headers = {
        'token': sdkToken,
        'content-type': 'application/json'
      };
      final Client client = Client();
      BundleInfo resultBundleInfo = await bundleInfo(client, uri, headers);
      if (!Globals.isProduction) {
        resultBundleInfo = BundleInfo(
            bundleUrl: Globals.bundleUrlSample,
            transVersion: resultBundleInfo.transVersion);
      }
      int transVersion = resultBundleInfo.transVersion;
      _log.d("Bundle info translate version: $transVersion");
      Archive archiveData = Archive();
      bool newRelease = false;
      if (transVersion != trVersion) {
        final bundleFile =
            await Downloader.downloadBundle(resultBundleInfo.bundleUrl);
        archiveData = ZipDecoder().decodeBytes(bundleFile);
        newRelease = true;
      }
      return BundleArchive(transVersion, archiveData, newRelease);
    } on ApiException {
      rethrow;
    } on UpdateException {
      rethrow;
    } on SdkException {
      SdkStore.removeStoredReleaseData();
      rethrow;
    } catch (e) {
      _log.i("Api getBundleData - $e");
      rethrow;
    }
  }

  // Request to Lokalise server for bundle info
  static Future<BundleInfo> bundleInfo(
      http.Client client, uri, Map<String, String> headers) async {
    final response = await client.get(uri, headers: headers);
    _log.d("Bundle info response status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      _log.d("Response body: ${response.body}");
      return BundleInfo.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 204) {
      throw UpdateException();
    } else if (response.statusCode == 404) {
      throw SdkException("Bundle not found");
    }
    throw ApiException('Failed to fetch bundle info', response.statusCode,
        Functions.formatJsonMessage(response.body));
  }
}
