import 'dart:async';

import 'package:logging/logging.dart';
import 'package:intl/intl.dart' show DateFormat;

class LoggerService {
  Logger _log;
  final DateFormat _dateFormatter = new DateFormat("H:m:s.S");

  final String appName;
  final bool debugMode;
  final bool verbose;

  LoggerService({this.appName: "my_app", this.debugMode: true, this.verbose: false}) {
    Logger.root.level = Level.ALL;

    if (debugMode) {
      Logger.root.onRecord.listen(verbose ? _verboseRecordHandler  : _recordHandler);
    }

    _log = new Logger(appName);
  }

  void _recordHandler(LogRecord rec) {
    // for better response time, do it async (since the onRecord stream is sync)
//    new Future(() {
    print('${rec.level.name} (${_dateFormatter.format(rec.time)}): ${rec.message}');
    _errorHandler(rec);
//    });
  }

  void _verboseRecordHandler(LogRecord rec) {
    // for better response time, do it async (since the onRecord stream is sync)
    new Future(() {
      print("${rec.time}:${rec.loggerName}:${rec.sequenceNumber}\n"
          "${rec.level}: ${rec.message}");

      _errorHandler(rec);
    });
  }

  void _errorHandler(LogRecord rec) {
    if (rec.error != null) {
      print("Cause: ${rec.error}");
    }

    if (rec.stackTrace != null) {
      print("${rec.stackTrace}");
    }
  }

  /** Log message at level [Level.FINEST]. */
  void finest(message, [Object error, StackTrace stackTrace]) =>
      _log.finest(message, error, stackTrace);

  /** Log message at level [Level.FINER]. */
  void finer(message, [Object error, StackTrace stackTrace]) =>
      _log.finer(message, error, stackTrace);

  /** Log message at level [Level.FINE]. */
  void fine(message, [Object error, StackTrace stackTrace]) =>
      _log.fine(message, error, stackTrace);

  /** Log message at level [Level.CONFIG]. */
  void config(message, [Object error, StackTrace stackTrace]) =>
      _log.config(message, error, stackTrace);

  /** Log message at level [Level.INFO]. */
  void info(message, [Object error, StackTrace stackTrace]) =>
      _log.info(message, error, stackTrace);

  /** Log message at level [Level.WARNING]. */
  void warning(message, [Object error, StackTrace stackTrace]) =>
      _log.warning(message, error, stackTrace);

  /** Log message at level [Level.SEVERE]. */
  void severe(message, [Object error, StackTrace stackTrace]) =>
      _log.severe(message, error, stackTrace);

  /** Log message at level [Level.SHOUT]. */
  void shout(message, [Object error, StackTrace stackTrace]) =>
      _log.shout(message, error, stackTrace);
}