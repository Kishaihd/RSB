import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:newRSB/services/firebase_service.dart';
import 'package:newRSB/services/logger_service.dart';

@Component(
  selector: 'menu-view',
  styleUrls: const ['menu_view.css'],
  templateUrl: 'menu_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders],
)
class MenuView {
  final LoggerService _log;
  final FirebaseService fbService;

  List<String> _availableLanguages = [];
  @Input()
  void set availableLanguages(List lm) {
    _log.info("$runtimeType::set availableLanguages($lm)");
    if (_availableLanguages != lm) {
      _availableLanguages = lm;
      initMe();
    }
  }
  List get availableLanguages => _availableLanguages;

  List<String> _myLanguages = [];
  @Input()
  void set myLanguages(List mll) {
    _log.info("$runtimeType::set myLanguages($mll)");
    if (_myLanguages != mll) {
      _myLanguages = mll;
      initMe();
    }
  }
  List get myLanguages => _myLanguages;

  List<String> unaddedLanguages = [];
//  List<String> myLanguages = [];


  initMe() {
    _log.info("$runtimeType::initMe()");
    if (_availableLanguages == null || _availableLanguages.isEmpty) {
      _log.info("$runtimeType::initMe()::available languages = null or empty!");
      return;
    }
    unaddedLanguages = _availableLanguages;
    if (_myLanguages == null || _myLanguages.isEmpty) {
      _log.info("$runtimeType::initMe() --_myLanguages = ${_myLanguages}");
      return;
    }
    _myLanguages.forEach((String language) {
      _log.info("$runtimeType::initMe()::found $language...");
      if (unaddedLanguages.contains(language)) {
        _log.info("$runtimeType::initMe()::removing $language from list of unadded languages...");
        unaddedLanguages.remove(language);
      }
    });
  }

  void switchToLanguage(String lang) {
    fbService.currentLanguage = lang;
  }

  MenuView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
  }

}
