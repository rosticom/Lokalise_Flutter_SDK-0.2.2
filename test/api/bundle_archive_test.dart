import 'dart:io' as io;
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/ota/api/downloader.dart';
import 'package:lokalise_flutter_sdk/ota/demo/globals.dart';
import 'package:lokalise_flutter_sdk/ota/service/bundle_data.dart';
import 'package:lokalise_flutter_sdk/ota/service/bundle_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'bundle_archive_test.mocks.dart';

@GenerateMocks([http.Client])

/// Bundle archive tests
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  group('Bundle downloader test', () {
    test('returns an Bundle if downloaded', () async {
      final client = MockClient();
      when(client.get(Uri.parse(Globals.bundleUrlSample))).thenAnswer(
          (_) async => http.Response(
              'locale/, locale/ar_BH.json, locale/en.json, locale/uk.json',
              200));
      expect(await Downloader.downloadBundle(Globals.bundleUrlSample),
          isA<List<int>>());
    });
    test(
        'throws an exception "Failed to download bundle file" if wrong url (argument error)',
        () {
      final client = MockClient();
      when(client.get(Uri.parse(Globals.bundleUrlSample)))
          .thenThrow(ArgumentError());
      expect(Downloader.downloadBundle("wrong url"),
          throwsA(isA<ArgumentError>()));
    });
    test('returns an BundleData if extracted', () async {
      Archive bundleArchive = Archive();
      var encoder = ZipFileEncoder();
      encoder.create("test/testPath/test.zip");
      encoder.addDirectory(io.Directory("test/assets/locale"));
      encoder.close();
      final zipFile = io.File("test/testPath/test.zip");
      final bytes = await zipFile.readAsBytes();
      bundleArchive = ZipDecoder().decodeBytes(bytes);
      expect(await BundleService.bundleExtract(bundleArchive),
          isInstanceOf<BundleData>());
    });
    test(
        'throws an exception - failed to extracted BundleData (wrong archive) if wrong archive format',
        () async {
      Archive bundleArchive = Archive();
      var encoder = ZipFileEncoder();
      encoder.create("test/testPath/test.zip");
      encoder.close();
      final zipFile = io.File("test/testPath/test.zip");
      final bytes = await zipFile.readAsBytes();
      bundleArchive = ZipDecoder().decodeBytes(bytes);
      expect(BundleService.bundleExtract(bundleArchive), throwsException);
    });
  });
}
