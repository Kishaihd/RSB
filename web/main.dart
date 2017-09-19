import 'package:angular/angular.dart';
import 'package:newRSB/main_app.dart';
import 'package:newRSB/services/firebase_service.dart';
import 'package:newRSB/services/logger_service.dart';

const String APP_NAME = "newRSB";
final LoggerService _log = new LoggerService(appName: APP_NAME);

void main() {
  bootstrap(MainApp, [
    provide(LoggerService, useValue: _log),
    provide(FirebaseService)
  ]);
}
