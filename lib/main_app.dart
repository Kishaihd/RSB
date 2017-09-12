/* AngularDart info: https://webdev.dartlang.org/angular
   Components info: https://webdev.dartlang.org/components */
// Necessary?
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';
import 'views/login_view/login_view.dart';
import 'views/menu_view/menu_view.dart';
//import 'views/vocab_list_component/vocab_list_component.dart';
//import 'views/noun_view/noun_view.dart';
import 'views/language_view/language_view.dart';
import 'views/lang_msg/lang_msg.dart';
//import 'models/learner.dart';
//import 'views/verb_view/verb_view.dart';

@Component(
  selector: 'main-app',
  styleUrls: const ['main_app.css'],
  templateUrl: 'main_app.html',
  directives: const [CORE_DIRECTIVES, materialDirectives, LoginView, MenuView, LanguageView, LangMsg],
  providers: const [materialProviders],
)
class MainApp implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;

  List<String> languageList;
  String language;
//  @Input()
//  void set language(String lang) {
//    if (_language != lang) {
//      _language = lang;
//      _initMe();
//    }
//  }
//  String get language => _language;
//
//  void _initMe() {
//    _log.info("$runtimeType()::_initMe()");
//    if (_language == null) {
//      return;
//    }
//    _log.info("$runtimeType()::initMe()::--success!");
//  }
//  String langMsg;

  List<String> views = const [
    "menuView",
    "languageView"
  ];
  String currentView;

//  @override
  void ngOnInit() { // async {
    _log.info("$runtimeType()::ngOnInit()");

//    language = "russian"; ///todo: Manually setting language is for debug purposes only.
    _log.info("$runtimeType()::defaultContructor()::fbService.getLangList()");
    fbService.getLangList();
//    _log.info("$runtimeType()::defaultContructor()::languages = ${fbService?.languages}");
    _log.info("$runtimeType()::defaultContructor()::fbService.getAllLangMeta()");
    fbService.getAllLangMeta();
//    _log.info("$runtimeType()::defaultContructor()::langMeta = ${fbService?.allLanguageMeta}");
    _log.info("$runtimeType()::defaultContructor()::fbService.getAllLangData");
    fbService.getAllLangData();
//    _log.info("$runtimeType()::defaultContructor()::fullLanguagedata = ${fbService?.allLanguageData}");

    ///todo: Nested ternary operators?
    language = (fbService?.learner?.currentLanguage != null ? fbService.learner.currentLanguage : (fbService.selectedLanguage != null ? fbService.selectedLanguage : " "));
    _log.info("Nested turnary:: language = (${fbService?.learner?.currentLanguage} != null ? ${fbService.learner.currentLanguage} : (${fbService.selectedLanguage} != null ? ${fbService.selectedLanguage} : " "))");
//    if (fbService?.learner?.currentLanguage != null && fbService.learner.currentLanguage.isNotEmpty) {
//      language = fbService.learner.currentLanguage;
//      _log.info("$runtimeType()::ngOnInit()::learner.currentLanguage = ${fbService?.learner?.currentLanguage}");
//      _log.info("$runtimeType()::ngOnInit()::fbService.selectedLanguage = ${fbService?.selectedLanguage}");
//    }
  }

  MainApp(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
//    _log.info("$runtimeType()::fbService.selectedLanguage::${fbService.selectedLanguage}");
//    currentView = views[0];
////    language = "russian"; ///todo: Manually setting language is for debug purposes only.
//    _log.info("$runtimeType()::defaultContructor()::fbService.getLangList()");
//    fbService.getLangList();
////    fbService.fbLangList.onValue.listen((firebase.QueryEvent e) async {
////      fbService.languages = await e.snapshot.val();
////      _log.info("$runtimeType()::defaultConstructor():: languages ${fbService.languages}");
////      _log.info("$runtimeType()::defaultConstructor()::fbLangList e.snapshot.val() ${e.snapshot.val()}");
////      _log.info("$runtimeType()::defaultConstructor()::fbLangList e.snapshot.val().runtimeType ${e.snapshot.val().runtimeType}");
////    });
//    _log.info("$runtimeType()::defaultContructor()::languages = ${fbService.languages}");
//
//
////    _log.info("$runtimeType()::defaultContructor()::fbService.getUserMeta()");
////    fbService.getUserMeta();
////    _log.info("$runtimeType()::defaultContructor()::userMeta = ${fbService.umm}");
////    fbService.fbUserMeta.onChildAdded.listen((firebase.QueryEvent e) {
////      _log.info("$runtimeType()::fbUserMeta.onChildAdded.listen(): ${e.snapshot.val()}");
////    });
//
//
//    _log.info("$runtimeType()::defaultContructor()::fbService.getAllLangMeta()");
//    fbService.getAllLangMeta();
//    _log.info("$runtimeType()::defaultContructor()::langMeta = ${fbService.allLanguageMeta}");
//
//
//    _log.info("$runtimeType()::defaultContructor()::fbService.getAllLangData");
//    fbService.getAllLangData();
//    _log.info("$runtimeType()::defaultContructor()::fullLanguagedata = ${fbService.allLanguageData}");
//
////    _log.info("$runtimeType()::defaultConstructor()::fbService.getVocabLists(${fbService?.learner?.uid}");
////    fbService.getVocabLists(fbService?.learner?.uid);
////    _log.info("$runtimeType()::defaultConstructor()::vocab for ${fbService?.learner?.uid}: ${fbService.learner.vocabLists}");
////    if (fbService.learner != null && fbService.learner?.currentLanguage.isNotEmpty) {
////      language = fbService.learner.currentLanguage;
////    }
////    if (fbService.learner != null) {
////      if (fbService.learner.hasLanguages){
////        if (fbService.learner.currentLanguage.isNotEmpty) {
////          language = fbService.learner.currentLanguage;
////        }
////        else {
////          language = fbService.learner.myLanguages[0];
////        }
////      }
////    }
////    else {
////      language = fbService.languages[0];
////    }
  }

  void changeMenu(int idx) {
    currentView = views[idx];
  }

//  void showMenu() {
//
//  }
//
//  void showKnowledge() {
//
//  }
}
