
//import 'dart:html';
import 'dart:async';
import'package:angular2/angular2.dart';
//import 'package:firebase/firebase.dart' as firebase;
//import 'package:firebase/src/assets/assets.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';
//import '../../models/learner.dart';
import 'package:angular2/core.dart';


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

  List<String> _langList = [];
  @Input()
  void set langList(List lm) {
    if (_langList != lm) {
      _langList = lm;
      _initMe();
    }
  }
  List get langList => _langList;

  List<String> displayList = [];

//  Map testFullLangMeta = {};
//  Map testFullLangData = {};

  Future<Null> _initMe() async {
    _log.info("$runtimeType()::_initMe()");
    if (langList == null) {
      _langList = await fbService.getLangList();
    }
    displayList = langList;
//    displayList.addAll(langList.reversed);
    _log.info("$runtimeType()::initMe():: fbService.learner = ${fbService.learner}");
    _log.info("$runtimeType()::initMe():: fbService.learner.hasLanguages = ${fbService.learner.hasLanguages}");
    if (fbService?.learner != null && fbService.learner.hasLanguages == true) {
      displayList.forEach((String lang) {
        if (fbService.learner.myLanguages.contains(lang)) {
          displayList.remove(lang); // Only display languages that the user doesn't already have.
          _log.info("$runtimeType()::initMe():: -- user list already contains $lang. --removing $lang from display list.");
        }
      });
    }
    _log.info("$runtimeType()::_initMe() -- Success!");
  }

  MenuView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
//    _langList = fbService.getLangList();
  }

  void addLanguage(String lang) {
    _log.info("$runtimeType()::addLanguage($lang)");
    if (fbService.learner != null) {
      fbService.learner.addLanguage(lang);
      displayList.remove(lang); // Remove added language from display list!
    }
  }

  void joinGroup(String id) {
    _log.info("$runtimeType()joinGroup($id)");
  }

}