import 'release_data.dart';

class StoredReleaseData {
  final String projectId;
  final ReleaseData releaseData;

  StoredReleaseData(this.projectId, this.releaseData);

  StoredReleaseData.fromJson(Map<String, dynamic> json)
      : projectId = json['projectId'],
        releaseData = ReleaseData.fromJson(json['releaseData']);

  Map<String, dynamic> toJson() =>
      {'projectId': projectId, 'releaseData': releaseData};
}
