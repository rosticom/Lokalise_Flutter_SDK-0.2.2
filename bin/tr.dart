library lokalise_flutter_sdk;

import 'package:lokalise_flutter_sdk/src/generator/generator.dart';
import 'package:lokalise_flutter_sdk/src/generator/generator_exception.dart';
import 'package:lokalise_flutter_sdk/src/utils/utils.dart';

Future<void> main(List<String> args) async {
  try {
    var generator = Generator();
    await generator.generateAsync();
  } on GeneratorException catch (e) {
    exitWithError(e.message);
  } catch (e) {
    exitWithError('Failed to generate localization files.\n$e');
  }
}
