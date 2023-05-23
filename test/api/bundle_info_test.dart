import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lokalise_flutter_sdk/ota/api/api.dart';
import 'package:lokalise_flutter_sdk/ota/model/bundle_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'bundle_info_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    Api.uri = Uri.parse("");
  });
  group('Get bundle info test', () {
    test('returns an BundleInfo if the http call completes successfully',
        () async {
      final client = MockClient();
      when(
          client
              .get(Api.uri, headers: {})).thenAnswer((_) async => http.Response(
          '{"url": "https://mdn01.lokalise.co/bundles/ProjectId/ios/6104.zip", "version": 4563}',
          200));
      expect(await Api.bundleInfo(client, Api.uri, {}), isA<BundleInfo>());
    });
    test(
        'throws an Update exception (do nothing) if the http call completes with code (204: "Nothing to update")',
        () {
      final client = MockClient();
      when(client.get(Api.uri, headers: {}))
          .thenAnswer((_) async => http.Response('Nothing to update', 204));
      expect(Api.bundleInfo(client, Api.uri, {}), throwsException);
    });
    test(
        'throws an exception "Incorect request parameter" if the http call completes with an error (400)',
        () {
      final client = MockClient();
      when(client.get(Api.uri, headers: {})).thenAnswer((_) async =>
          http.Response('Missing request parameter {appVersion}', 400));
      expect(Api.bundleInfo(client, Api.uri, {}), throwsException);
    });
    test(
        'throws an exception "Unauthorized" if the http call completes with an error (401)',
        () {
      final client = MockClient();
      when(client.get(Api.uri, headers: {}))
          .thenAnswer((_) async => http.Response('Not authorised', 401));
      expect(Api.bundleInfo(client, Api.uri, {}), throwsException);
    });
    test(
        'throws an exception "OTA is not available" if the http call completes with an error (403)',
        () {
      final client = MockClient();
      when(client.get(Api.uri, headers: {}))
          .thenAnswer((_) async => http.Response('OTA is not available', 403));
      expect(Api.bundleInfo(client, Api.uri, {}), throwsException);
    });
    test(
        'SdkException (clear the cache) if the http call completes with 404: "Bundle not found"',
        () {
      final client = MockClient();
      when(client.get(Api.uri, headers: {}))
          .thenAnswer((_) async => http.Response('Bundle not found', 404));
      expect(Api.bundleInfo(client, Api.uri, {}), throwsException);
    });
    test(
        'throws an exception "Something went wrong" if the http call completes with an error (500)',
        () {
      final client = MockClient();
      when(client.get(Api.uri, headers: {}))
          .thenAnswer((_) async => http.Response('Internal Server Error', 500));
      expect(Api.bundleInfo(client, Api.uri, {}), throwsException);
    });
  });
}
