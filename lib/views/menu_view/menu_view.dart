
import 'dart:async';
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
class MenuView { //implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;

  List<String> _availableLanguages = [];
  @Input()
  void set availableLanguages(List lm) {
    if (_availableLanguages != lm) {
      _availableLanguages = lm;
      _initMe();
    }
  }
  List get availableLanguages => _availableLanguages;

  List<String> _myLanguages = [];
  @Input()
  void set myLanguages(List mll) {
    if (_myLanguages != mll) {
      _myLanguages = mll;
      _initMe();
    }
  }
  List get myLanguages => _myLanguages;

  List<String> unaddedLanguages = [];
  List<String> myOtherLanguages = [];

//  Map testFullLangMeta = {};
//  Map testFullLangData = {};

  Future<Null> _initMe() async {
    _log.info("$runtimeType()::_initMe()");
//    unaddedLanguages = _availableLanguages;
//    myOtherLanguages = _myLanguages;
    await fbService.getUserLangList();
//    await fbService.getUserLangList(fbService.fbUser.uid);
//    if (langList == null || langList.isEmpty) {
//      _langList = await fbService.getLangList();
//    }
//    displayList = langList;
//    displayList.addAll(langList.reversed);
    _log.info("$runtimeType()::initMe():: fbService.learner = ${fbService.learner}");
    _log.info("$runtimeType()::initMe():: fbService.learner.hasLanguages = ${fbService.learner.hasLanguages}");
//    if (fbService?.learner != null && fbService.learner.myLanguages != null && fbService.learner.myLanguages.isNotEmpty) {
//    myOtherLanguages = fbService.learner.myLanguages;
//    myOtherLanguages = await fbService.getUserLangList();
      _availableLanguages.forEach((String lang) {
//        if (fbService.learner.myLanguages.contains(lang)) {
        if (myOtherLanguages.contains(lang) == false && unaddedLanguages.contains(lang) == false) {
            unaddedLanguages.add(lang); // Only display languages that the user doesn't already have.
          //          _log.info("$runtimeType()::initMe():: -- user list already contains $lang. --removing $lang from display list.");
        }
      });
      unaddedLanguages.forEach((String lang) {
        if (myOtherLanguages.contains(lang)) {
          unaddedLanguages.remove(lang);
        }
      });
//    }
  }

  MenuView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
    unaddedLanguages = _availableLanguages;
    myOtherLanguages = _myLanguages;
//    _initMe();
//    _langList = fbService.getLangList();
  }

  void addLanguage(String lang) {
    _log.info("$runtimeType()::addLanguage($lang)");
    if (fbService.learner != null) {
      fbService.learner.addLanguage(lang);
      unaddedLanguages.remove(lang); // Remove added language from display list!
    }
  }

  void switchToLang(String lang) {
    _log.info("$runtimeType()::switchToLang($lang)");
    fbService.selectedLanguage = lang;
  }

  void joinGroup(String id) {
    _log.info("$runtimeType()joinGroup($id)");
  }

}