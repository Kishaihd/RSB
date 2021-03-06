import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
//import '../../services/noun_service.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';

@Component(
  selector: 'noun-view',
  styleUrls: const ['noun_view.css'],
  templateUrl: 'noun_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders],//, LoggerService],
)
class NounView implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;

//  Map<String, List<Map<String, dynamic>>> masterMap; // the dynamic is either string or a map.
//Map<gender, Map<example index, Map<case, Map<sing_or_plurl, word>>>  OR
//Map<gender, Map<index, Map<type/word, desc/example>>>

  Map<String, Map<String, Map<String, dynamic>>> _nounDataMap;
  @Input()
  void set nounDataMap(Map<String, Map<String, Map<String, dynamic>>> ndm) {
    if (_nounDataMap != ndm) {
      _nounDataMap = {};
      initializeMe();
    }
  }

  Map<String, Map<String, Map<String, dynamic>>> get nounDataMap => _nounDataMap;

  Map<String, String> _nounMetaMap;
  @Input()
  void set nounMetaMap(Map<String, String> nmm) {
    if (_nounMetaMap != nmm) {
      _nounMetaMap = {};
      initializeMe();
    }
  }

  Map<String, String> get nounMetaMap => _nounMetaMap;

  List<String> views = const [
    "referenceView",
    "notesView"
  ];
  String currentView = "";

//  List<String> wordList = [];
//  List<String> defList = [];

//  String newWord = "";
//  String newDef = "";


//  @override
  Future<Null> ngOnInit() async {
    ///todo: Is this right?
    initializeMe();
//    if (_nounDataMap.isEmpty) {
//      if (fbService.learner.currentLanguage != "") { // fbService.learner.currentLanguage != null && // Just the check for empty string should be sufficient.
//        fbService.changeLang(fbService.selectedLanguage);
////        fbService.changeLang(fbService.learner.currentLanguage);
//        _nounDataMap = await fbService.singleLangData;
//        _nounMetaMap = await fbService.singleLangMeta;
//      }
//    }
    currentView = views.elementAt(0); // 0th index should be first view.
//
//    if (fbService.learner.checkComplete() == false) {
//
//    }
  } // End ngOnInit()

  void initializeMe() {
    if (_nounDataMap == null || _nounMetaMap == null) {
      return;
      _log.info("$runtimeType()::initializeMe()::--data inputs are null!");
    }
    else {
      _log.info("$runtimeType()::initializeMe()::--success!");
    }
  }

  NounView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
  }

  Future<Null> getLanguage(String lang) async {
//    nounDataMap = await fbService.fullLanguageData[lang]["nouns"];
//    nounMetaMap = await fbService.la[lang]["nouns"];
    _nounDataMap = await fbService.getSingleLangData(lang);
    _nounMetaMap = await fbService.getSingleLangMeta(lang);
  }

} // end class NounView



//  void add(String word, [String definition = ""]) {
////    vocabMap.putIfAbsent(word, () => word);
////    vocabMap[word] = definition;
//    // I think this does the above two functions in one line.
//    wordList.add(word);
//    defList.add(definition);
////    vocabMap[word] = definition;
//    //newSetWords.add(description);
//  }
////  String remove(int index) => newListWords.removeAt(index);
//  void remove(String word) {
//    int idx = wordList.indexOf(word);
//    wordList.removeAt(idx);
//    defList.removeAt(idx);
////    vocabMap.remove(word);
//  }
//  void onReorder(ReorderEvent e) => vocabMap.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
//      newListWords.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));