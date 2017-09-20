import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';

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

  int numLanguages = 3;

  List<String> _availableLanguages = [];
  @Input()
  void set availableLanguages(List lm) {
    _log.info("$runtimeType::set availableLanguages($lm)");
    if (_availableLanguages != lm) {
      _availableLanguages = lm;
      if (_availableLanguages != null && _availableLanguages.isNotEmpty) {
        _log.info("$runtimeType::set availableLanguages():: populating language list...");
        numLanguages = 0;
        _availableLanguages.forEach((String entry) => numLanguages += 1);
        _log.info("$runtimeType::set availableLanguages():: $numLanguages found.");
      }
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
      _availableLanguages = [];
      return;
    }
    unaddedLanguages = _availableLanguages;
    if (_myLanguages == null || _myLanguages.isEmpty) {
      _log.info("$runtimeType::initMe() --_myLanguages = ${_myLanguages}");
      _myLanguages = [];
      return;
    }
    else {
      _myLanguages.forEach((String language) {
        _log.info("$runtimeType::initMe()::found $language...");
        if (unaddedLanguages.contains(language)) {
          _log.info("$runtimeType::initMe()::removing $language from list of unadded languages...");
          unaddedLanguages.remove(language);
        }
      });
    }
  }

  void switchToLanguage(String lang) {
    _log.info("$runtimeType::switchToLanguage($lang)");
    fbService.currentLanguage = lang;
  }

  void addLanguage(String lang) {
    _log.info("$runtimeType::addLanguage($lang)");
    fbService.learner.addLanguage(lang);
    fbService.currentLanguage = lang;
    fbService.updateLearnerInDB();
  }

  MenuView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
  }

}
