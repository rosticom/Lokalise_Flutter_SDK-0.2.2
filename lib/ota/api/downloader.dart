import 'package:lokalise_flutter_sdk/ota/service/logger.dart';
import 'package:universal_io/io.dart';
import 'package:lokalise_flutter_sdk/ota/exeptions/api_exception.dart';

class Downloader {
  static final _log = getLogger();

  /// Download bundle
  static Future<List<int>> downloadBundle(String url) async {
    try {
      final httpClient = HttpClient();
      final response = await httpClient
          .getUrl(Uri.parse(url))
          .onError((Object e, StackTrace stackTrace) {
        throw ApiException('Failed to download bundle file', 0, e.toString());
      }).then((request) => request.close());
      if (response.statusCode != 200) {
        _log.i(
            "Downloader - Failed to download bundle file - status code: $response.statusCode");
        throw ApiException(
            'Failed to download bundle file', response.statusCode);
      } else {
        return await response.fold([], (List<int> accumulator, List<int> next) {
          return accumulator..addAll(next);
        });
      }
    } on ApiException {
      _log.i("Downloader download - Failed to download bundle file");
      rethrow;
    } catch (e) {
      _log.i("Downloader download - Failed to download bundle file - $e");
      rethrow;
    }
  }
}
