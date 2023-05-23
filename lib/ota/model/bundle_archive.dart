import 'package:archive/archive.dart';

class BundleArchive {
  final int transVersion;
  final Archive bundleArchive;
  final bool newRelease;

  BundleArchive(this.transVersion, this.bundleArchive, this.newRelease);
}
