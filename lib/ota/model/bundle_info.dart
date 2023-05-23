class BundleInfo {
  final String bundleUrl;
  final int transVersion;

  BundleInfo({required this.bundleUrl, required this.transVersion});

  /// Get bundle info from json
  BundleInfo.fromJson(Map<String, dynamic> json)
      : bundleUrl = json['url'],
        transVersion = json['version'];
}
