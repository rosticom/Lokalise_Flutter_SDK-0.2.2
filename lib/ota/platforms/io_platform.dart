import 'package:lokalise_flutter_sdk/ota/data/sdk_ota_data.dart';
import 'package:lokalise_flutter_sdk/ota/model/stored_release_data.dart';
import 'package:lokalise_flutter_sdk/ota/platforms/platform.dart';
import 'dart:convert' as convert;
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart' as path_provider;

Platform createPlatform() => IOPlatform();

class IOPlatform implements Platform {
  static const String _lokaliseReleaseDataFile = 'lokalise_release_data.json';

  @override

  /// Get locale from native device
  String getLocale() {
    return SdkOtaData.canonicalizedLocale(io.Platform.localeName);
  }

  @override

  /// Get data cache from native device
  Future<StoredReleaseData?> getStoredReleaseData() async {
    var file = await _getStoredReleaseDataFile();
    if (!file.existsSync()) {
      return null;
    }
    var content = await file.readAsString();
    var json = convert.jsonDecode(content);
    return StoredReleaseData.fromJson(json);
  }

  @override

  /// Remove data cache from native device
  Future<void> removeStoredReleaseData() async {
    var file = await _getStoredReleaseDataFile();
    if (file.existsSync()) {
      await file.delete();
    }
  }

  @override

  /// Save data cache to native device
  Future<void> saveStoredReleaseData(StoredReleaseData data) async {
    var file = await _getStoredReleaseDataFile();
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
    var content = convert.jsonEncode(data);
    await file.writeAsString(content);
  }

  /// Get data file from native device
  Future<io.File> _getStoredReleaseDataFile() async {
    var dir = await path_provider.getApplicationSupportDirectory();
    var filePath = '${dir.path}/$_lokaliseReleaseDataFile';
    return io.File(filePath);
  }
}
