
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';
import 'views/login_view/login_view.dart';
import 'views/menu_view/menu_view.dart';
import 'views/language_view/language_view.dart';
import 'views/language_message/lang_msg.dart';
//import 'src/todo_list/todo_list_component.dart';

@Component(
  selector: 'main-app',
  styleUrls: const ['main_app.css'],
  templateUrl: 'main_app.html',
  directives: const [CORE_DIRECTIVES, materialDirectives, LoginView, MenuView, LanguageView, LanguageMessage], //, TodoListComponent],
  providers: const [materialProviders],
)
class MainApp implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;

  List<String> views = const [
    "menuView",
    "languageView"
  ];
  String currentView;

  List<String> languages = [];
  List<String> myLanguages = [];

//  List<String> getLangs() {
//    if (languages.isEmpty) {
//      fbService.getLanguageList().then((ll) {
//        languages = ll;
//        return ll;
//      });
//    }
//    else {
//      return languages;
//    }
//    return languages;
//  }

  @override
  ngOnInit() async {
    _log.info("$runtimeType::ngOnInit()");
    languages = await fbService.getLanguageList();
    _log.info("$runtimeType::ngOnInit()::languages = $languages");
    await fbService.getLanguagesData();
    await fbService.getLanguagesMeta();
    if (fbService.fbUser != null) {
      _log.info("$runtimeType::ngOnInit()::fbService.fbUser = ${fbService.fbUser}");
      fbService.getUserData(fbService.fbUser.uid).then((newLearner) {
        _log.info("$runtimeType::ngOnInit():: newLearner: keys =  ${newLearner.keys}\nValues = ${newLearner.values}");
        _log.info("$runtimeType::ngOnInit():: newLearner.myLanguages =  ${newLearner['myLanguages']}");
//        _log.info("$runtimeType::ngOnInit():: fbService.learner.myLanguages =  ${fbService?.learner?.myLanguages}");
  //      myLanguages = newLearner
  //          fbService?.learner?.myLanguages;
      });
    }
//    myLanguages = fbService.learner.myLanguages;
  }

  MainApp(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
    currentView = views.elementAt(0);
  }

//  List<String> getLangList() {
//    if (fbService.languageList == null || fbService.languageList.isEmpty) {
//      fbService.getLanguageList().then((llist) {
//        languages = llist;
//        return llist;
//      });
//    }
//    return languages;
//  }

  void changeMenu(int idx) {
    _log.info("$runtimeType::changeMenu(${views.elementAt(idx)})");
    currentView = views[idx];
  }

}
