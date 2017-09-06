//import 'dart:async';
//import 'dart:collection'; // In case I use a SplayTreeMap
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';



@Component(
  selector: 'flashcard',
  styleUrls: const ['flashcard.css'],
  templateUrl: 'flashcard.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders],
)
class Flashcard {
  final LoggerService _log;
  final FirebaseService fbService;

  Flashcard(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
  }
}