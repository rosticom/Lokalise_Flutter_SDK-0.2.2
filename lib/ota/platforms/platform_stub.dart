import 'platform.dart';

Platform createPlatform() => throw UnsupportedError(
    'Cannot create a platform without dart:html or dart:io.');
