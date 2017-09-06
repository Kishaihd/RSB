//import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
//import '../../services/noun_service.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';

@Component(
  selector: 'verb-view',
  styleUrls: const ['verb_view.css'],
  templateUrl: 'verb_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders],//, LoggerService],
)
class VerbView { //implements OnInit {
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
  Map _verbDataMap = {};
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

  VerbView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
    currentView = views.elementAt(0); // 0th index should be first view.
  }

  //  void set verbDataMap(Map<String, Map<String, Map<String, dynamic>>> singleLangData) {
  @Input()
  void set verbDataMap(Map singleLangData) {
    _log.info("$runtimeType()::@Input set verbDataMap()");
    if (singleLangData.containsKey('nouns')) {
      _log.info("$runtimeType()::set verbDataMap() --contains key 'nouns' ");
      if (_verbDataMap != singleLangData["nouns"]) {
        _verbDataMap = singleLangData["nouns"];
        initializeMe();
      }
    }
  }
//  Map<String, Map<String, Map<String, dynamic>>>
  Map get verbDataMap => _verbDataMap;

  Map<String, dynamic> _verbMetaMap = {};
  @Input()
  void set verbMetaMap(Map<String, dynamic> singleLangMeta) {
    if (_verbMetaMap != singleLangMeta) {
      _verbMetaMap = singleLangMeta;
      initializeMe();
    }
  }
  Map<String, dynamic> get verbMetaMap => _verbMetaMap;

  void initializeMe() {
    _log.info("$runtimeType()::initMe():: _verbMetaMap = ${_verbMetaMap}");
    _log.info("$runtimeType()::initMe():: verbMetaMap = ${verbMetaMap}");
    if (_verbDataMap == null || _verbMetaMap == null) {
      _log.info("$runtimeType()::initializeMe()::--data inputs are null!");
      return;
    }
    _log.info("$runtimeType()::initMe()::hasDeclensions == ${_verbMetaMap['hasDeclensions']}");
    _log.info("$runtimeType()::initMe()::declensions order...");
//    decOrder = _verbMetaMap['declensionsOrderPreference'];
//    if (_verbMetaMap['hasDeclensions'] == true) {
//    if (_verbMetaMap.containsKey("hasDeclensions")) {
//      _log.info("$runtimeType()::initMe()::metaMap.containsKey(hasDeclensions) = ${_verbMetaMap.containsKey('hasDeclensions')}");
//      if (_verbMetaMap['hasDeclensions'] == true) {
//        _log.info("DECLENSIONS == TRUE!!!");
//      }
////      _log.info("$runtimeType()::initMe()::verbDataMap = ${_verbDataMap}");
////      _log.info("$runtimeType()::initMe()::verbDataMap['masculine'] = ${_verbDataMap['masculine']}");
////      _log.info("$runtimeType()::initMe()::verbDataMap['feminine'] = ${_verbDataMap['feminine']}");
////      _log.info("$runtimeType()::initMe()::verbDataMap['neuter'] = ${_verbDataMap['neuter']}");
////      _verbDataMap['masculine'][0].forEach((String decType, Map other) {
////        if (decType != 'type' && decType != 'word') { // don't add the example shits
////          declensionTypes.add(decType);
////          _log.info("$runtimeType()::initMe():: found declension type: $decType!");
////        }
//////        mascMap = _verbDataMap['masculine'];
////        mascList = _verbDataMap['masculine'];
////        _log.info("$runtimeType()::initMe()::mascList = $mascList");
//////        _log.info("$runtimeType()::initMe()::mascMap = $mascMap");
//////        femMap = _verbDataMap['feminine'];
////        femList = _verbDataMap['feminine'];
////        _log.info("$runtimeType()::initMe()::femList = $femList");
//////        _log.info("$runtimeType()::initMe()::femMap = $femMap");
////        if (_verbDataMap.containsKey('neuter')) {
//////          neutMap = _verbDataMap['neuter'];
////          neutList = _verbDataMap['neuter'];
////          _log.info("$runtimeType()::initMe():: neutList = $neutList");
//////          _log.info("$runtimeType()::initMe():: neutMap = $neutMap");
////        }
////      });
////      Map<String, Map<String, dynamic>> mascSingMap = {};
////      Map<String, Map<String, dynamic>> mascPlMap = {};
////      Map<String, Map<String, dynamic>> femSingMap = {};
////      Map<String, Map<String, dynamic>> femPlMap = {};
////      Map<String, Map<String, dynamic>> neutSingMap = {};
////      Map<String, Map<String, dynamic>> neutPlMap = {};
////      List<String> declensionTypes = [];
//    }
//    else {
//      _log.info("$runtimeType()::initMe():: --No declensions for this language!");
//    }
    /*** TEST ***/
//    mascList = _verbDataMap['masculine'];
//    _log.info("$runtimeType()::initMe()::mascList = $mascList");
////        _log.info("$runtimeType()::initMe()::mascMap = $mascMap");
////        femMap = _verbDataMap['feminine'];
//    femList = _verbDataMap['feminine'];
//    _log.info("$runtimeType()::initMe()::femList = $femList");
////        _log.info("$runtimeType()::initMe()::femMap = $femMap");
//    if (_verbDataMap.containsKey('neuter')) {
////          neutMap = _verbDataMap['neuter'];
//      neutList = _verbDataMap['neuter'];
//      _log.info("$runtimeType()::initMe():: neutList = $neutList");
////          _log.info("$runtimeType()::initMe():: neutMap = $neutMap");
//    }
    /*** TEST ***/
    _log.info("$runtimeType()::initializeMe()::--success!");
  }


} // end class NounView
