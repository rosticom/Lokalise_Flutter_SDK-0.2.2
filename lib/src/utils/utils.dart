import 'dart:io';

import 'package:dart_style/dart_style.dart' show DartFormatter;

/// Check locale
bool isLangScriptCountryLocale(String locale) =>
    RegExp(r'^[a-z]{2}_[A-Z][a-z]{3}_[A-Z]{2}$').hasMatch(locale);

/// Check locale
bool isLangScriptLocale(String locale) =>
    RegExp(r'^[a-z]{2}_[A-Z][a-z]{3}$').hasMatch(locale);

/// Check locale
bool isLangCountryLocale(String locale) =>
    RegExp(r'^[a-z]{2}_[A-Z]{2}$').hasMatch(locale);

/// Info
void info(String message) => stdout.writeln('INFO: $message');

/// Warning
void warning(String message) => stdout.writeln('WARNING: $message');

/// Error
void error(String message) => stderr.writeln('ERROR: $message');

/// Exit with error
void exitWithError(String message) {
  error(message);
  exit(2);
}

/// Formats Dart file content.
String formatDartContent(String content, String fileName) {
  try {
    var formatter = DartFormatter();
    return formatter.format(content);
  } catch (e) {
    info('Failed to format \'$fileName\' file.');
    return content;
  }
}
