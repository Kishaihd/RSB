
import 'package:angular/angular.dart';
//import 'package:angular_components/angular_components.dart';
import 'package:newRSB/services/logger_service.dart';

@Component(
  selector: 'lang-msg',
  styleUrls: const ['lang_msg.css'],
  templateUrl: 'lang_msg.html',
  directives: const [CORE_DIRECTIVES]
)
class LanguageMessage {
  final LoggerService _log;

  String _language;
  @Input()
  void set language(String lang) {
    if (_language != lang) {
      _language = lang;
      initMe();
    }
  }
  String get language => _language;

  String langMsg = "";

  initMe() {
    if (_language != null && _language.isNotEmpty) {
      langMsg = "Now viewing $_language";
    }
    else {
      langMsg = "No languages available!";
    }
  }


  LanguageMessage(LoggerService this._log) {
    _log.info("$runtimeType");
  }

}
