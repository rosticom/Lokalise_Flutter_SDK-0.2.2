import 'package:logger/logger.dart';

/// Log
Logger getLogger() {
  return Logger(printer: PrettyPrinter(methodCount: 0, lineLength: 55));
}
