import 'package:path/path.dart';

/// Default values for generator
class Default {
  static const defaultClassName = 'Tr';
  static const defaultMainLocale = 'en';
  static final defaultArbDir = join('lib', 'l10n');
  static final defaultOutputDir = join('lib', 'generated');
  static const defaultUseDeferredLoading = false;
  static const defaultOtaEnabled = true;
}
