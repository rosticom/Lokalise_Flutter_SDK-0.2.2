import 'package:lokalise_flutter_sdk/ota/model/stored_release_data.dart';
import 'platform_stub.dart'
    if (dart.library.html) 'browser_platform.dart'
    if (dart.library.io) 'io_platform.dart';

abstract class Platform {
  factory Platform() => createPlatform();

  String getLocale();

  Future<StoredReleaseData?> getStoredReleaseData();

  Future<void> saveStoredReleaseData(StoredReleaseData data);

  Future<void> removeStoredReleaseData();
}
