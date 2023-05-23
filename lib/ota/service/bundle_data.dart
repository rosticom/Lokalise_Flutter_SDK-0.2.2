import 'package:lokalise_flutter_sdk/ota/model/label_tr.dart';
import 'package:lokalise_flutter_sdk/ota/data/sdk_ota_data.dart';

class BundleData {
  final Map<String, Map<String, LabelTr>> data;

  BundleData({required this.data});

  /// Get bundle data from json
  BundleData.fromJson(List<dynamic> json)
      : data = {
          for (var localeData in json)
            SdkOtaData.canonicalizedLocale(localeData['locale']): {
              for (var labelData in localeData['data'] as List)
                labelData['key']: LabelTr.fromJson(labelData)
            }
        };
}
