import 'dart:async';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class AppLogger {
  static late File logFile;
  static const int maxFileSize = 1024 * 1024 * 5; // 5 MB
  static const int maxFiles = 10;

  static Future<void> initialize() async {
    Logger.root.level = Level.ALL;
    await _setupLogFile();
    _setupLogListener();
  }

  static Future<void> _setupLogFile() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    logFile = File('${dir.path}/app_logs.log');
    if (!await logFile.exists()) {
      await logFile.create(recursive: true);
    }
  }

  static void _setupLogListener() {
    Logger.root.onRecord.listen((record) async {
      final logEntry = '${record.time} [${record.level.name}] ${record.loggerName}: ${record.message}\n';

      if (kDebugMode) {
        print(logEntry);
      }

      // await _writeLog(logEntry);
    });
  }

  static void log(String name, String message, {Level level = Level.INFO}) {
    Logger logger = Logger(name);
    logger.log(level, message);
  }

  static void logInfo(String name, String message) {
    Logger(name).info(message);
  }

  static void logError(String name, String message) {
    Logger(name).severe(message);
  }
}
