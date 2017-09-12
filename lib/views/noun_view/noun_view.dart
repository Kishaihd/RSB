//import 'dart:async';
import 'package:angular/angular.dart';
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
  
  List<String> views = const [
    "referenceView",
    "notesView"
  ];
  String currentView = "";

  //  Map<String, List<Map<String, dynamic>>> masterMap; // the dynamic is either string or a map.
//Map<gender, Map<example index, Map<case, Map<sing_or_plurl, word>>>  OR
//Map<gender, Map<index, Map<type/word, desc/example>>>

//  Map<String, Map<String, Map<String, dynamic>>>
  Map _nounDataMap = {};
  List<Map> mascList = [];
  List<Map> femList = [];
  List<Map> neutList = [];
  Map mascMap = {};
  Map femMap = {};
  Map neutMap = {};

  List<String> decOrder = [];
//  Map<String, Map<String, dynamic>> mascSingMap = {};
//  Map<String, Map<String, dynamic>> mascPlMap = {};
//  Map<String, Map<String, dynamic>> femSingMap = {};
//  Map<String, Map<String, dynamic>> femPlMap = {};
//  Map<String, Map<String, dynamic>> neutSingMap = {};
//  Map<String, Map<String, dynamic>> neutPlMap = {};
  List<String> declensionTypes = [];

  NounView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
    currentView = views.elementAt(0); // 0th index should be first view.
  }

  //  void set nounDataMap(Map<String, Map<String, Map<String, dynamic>>> singleLangData) {
//  @Input()
//  void set nounDataMap(Map singleLangData) {
//    _log.info("$runtimeType()::@Input set nounDataMap()");
//    if (singleLangData.containsKey('nouns')) {
//      _log.info("$runtimeType()::set nounDataMap() --contains key 'nouns' ");
//      if (_nounDataMap != singleLangData["nouns"]) {
//        _nounDataMap = singleLangData["nouns"];
//        initMe();
//      }
//    }
//  }
//  Map<String, Map<String, Map<String, dynamic>>>
  Map get nounDataMap => _nounDataMap;

  Map<String, dynamic> _nounMetaMap = {};
//  @Input()
//  void set nounMetaMap(Map<String, dynamic> singleLangMeta) {
//    if (_nounMetaMap != singleLangMeta) {
//      _nounMetaMap = singleLangMeta;
//      initMe();
//    }
//  }
  Map<String, dynamic> get nounMetaMap => _nounMetaMap;

  ngOnInit() async {
    _log.info("$runtimeType()::initMe():: nounMetaMap = ${nounMetaMap}");
    if (_nounDataMap == null || _nounDataMap.isEmpty) {
      _log.info("$runtimeType()::initializeMe()::--data inputs are null or empty!");
      fbService.getAllLangData().then((allLangDat) async {
//      if (fbService.selectedLanguage != null && fbService.selectedLanguage.isNotEmpty) {
        _nounDataMap = allLangDat[await fbService.getSelectedLanguage()]['nouns'];
//      }
      ///todo: fill the different declension maps for each gender? Or is that done in HTML?
     });
    }
    if (_nounMetaMap == null || _nounMetaMap.isEmpty) {
      fbService.getAllLangMeta().then((allLangMet) async {
        _nounMetaMap = allLangMet[await fbService.getSelectedLanguage()];
        decOrder = _nounMetaMap['declensionsOrderPreference'];
      });
    }
//    _log.info("$runtimeType()::initMe()::hasDeclensions == ${_nounMetaMap['hasDeclensions']}");
//    _log.info("$runtimeType()::initMe()::declensions order...");
//
//    if (_nounMetaMap.containsKey("hasDeclensions")) {
//      _log.info("$runtimeType()::initMe()::metaMap.containsKey(hasDeclensions) = ${_nounMetaMap.containsKey('hasDeclensions')}");
//      if (_nounMetaMap['hasDeclensions'] == true) {
//        _log.info("DECLENSIONS == TRUE!!!");
//      }
//      _log.info("$runtimeType()::initMe()::mascList = $mascList");
//      _log.info("$runtimeType()::initMe()::femList = $femList");
//    }
//    else {
//      _log.info("$runtimeType()::initMe():: --No declensions for this language!");
//    }
//    _log.info("$runtimeType()::initializeMe()::--success!");
  }


} // end class NounView
