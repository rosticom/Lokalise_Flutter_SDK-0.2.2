import 'dart:convert';
import 'package:lokalise_flutter_sdk/src/utils/file_utils.dart';
import 'package:lokalise_flutter_sdk/src/utils/utils.dart';
import '../init/default.dart';
import 'generator_exception.dart';
import 'intl_translation_helper.dart';
import 'label.dart';
import 'templates.dart';

class Generator {
  late String _className;
  late String _mainLocale;
  late String _arbDir;
  late String _outputDir;
  late bool _useDeferredLoading;
  late bool _otaEnabled;

  Generator() {
    _className = Default.defaultClassName;
    _mainLocale = Default.defaultMainLocale;
    _arbDir = Default.defaultArbDir;
    _outputDir = Default.defaultOutputDir;
    _useDeferredLoading = Default.defaultUseDeferredLoading;
    _otaEnabled = Default.defaultOtaEnabled;
  }

  /// Generator
  Future<void> generateAsync() async {
    await _updateL10nDir();
    await _updateGeneratedDir();
    await _generateDartFiles();
  }

  /// Updater
  Future<void> _updateL10nDir() async {
    var mainArbFile = getArbFileForLocale(_mainLocale, _arbDir);
    if (mainArbFile == null) {
      await createArbFileForLocale(_mainLocale, _arbDir);
    }
  }

  /// Update generated folder
  Future<void> _updateGeneratedDir() async {
    var labels = _getLabelsFromMainArbFile();
    var locales = _orderLocales(getLocales(_arbDir));
    var content =
        generateL10nDartFileContent(_className, labels, locales, _otaEnabled);
    var formattedContent = formatDartContent(content, 'l10n.dart');
    await updateL10nDartFile(formattedContent, _outputDir);
    var intlDir = getIntlDirectory(_outputDir);
    if (intlDir == null) {
      await createIntlDirectory(_outputDir);
    }
    await removeUnusedGeneratedDartFiles(locales, _outputDir);
  }

  /// Get data from arb file
  List<Label> _getLabelsFromMainArbFile() {
    var mainArbFile = getArbFileForLocale(_mainLocale, _arbDir);
    if (mainArbFile == null) {
      throw GeneratorException(
          "Can't find ARB file for the '$_mainLocale' locale.");
    }
    var content = mainArbFile.readAsStringSync();
    var decodedContent = json.decode(content) as Map<String, dynamic>;
    var labels =
        decodedContent.keys.where((key) => !key.startsWith('@')).map((key) {
      var name = key;
      var content = decodedContent[key];
      var meta = decodedContent['@$key'] ?? {};
      var type = meta['type'];
      var description = meta['description'];
      var placeholders = meta['placeholders'] != null
          ? (meta['placeholders'] as Map<String, dynamic>)
              .keys
              .map((placeholder) => Placeholder(
                  key, placeholder, meta['placeholders'][placeholder]))
              .toList()
          : null;

      return Label(name, content,
          type: type, description: description, placeholders: placeholders);
    }).toList();
    return labels;
  }

  /// Locales order
  List<String> _orderLocales(List<String> locales) {
    var index = locales.indexOf(_mainLocale);
    return index != -1
        ? [
            locales.elementAt(index),
            ...locales.sublist(0, index),
            ...locales.sublist(index + 1)
          ]
        : locales;
  }

  /// Generate dart files
  Future<void> _generateDartFiles() async {
    var outputDir = getIntlDirectoryPath(_outputDir);
    var dartFiles = [getL10nDartFilePath(_outputDir)];
    var arbFiles = getArbFiles(_arbDir).map((file) => file.path).toList();
    var helper = IntlTranslationHelper(_useDeferredLoading);
    helper.generateFromArb(outputDir, dartFiles, arbFiles);
  }
}
