//import 'dart:async';
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
class NounView { //implements OnInit {
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
  @Input()
  void set nounDataMap(Map singleLangData) {
    _log.info("$runtimeType()::@Input set nounDataMap()");
    if (singleLangData.containsKey('nouns')) {
      _log.info("$runtimeType()::set nounDataMap() --contains key 'nouns' ");
      if (_nounDataMap != singleLangData["nouns"]) {
        _nounDataMap = singleLangData["nouns"];
        initializeMe();
      }
    }
  }
//  Map<String, Map<String, Map<String, dynamic>>>
  Map get nounDataMap => _nounDataMap;

  Map<String, dynamic> _nounMetaMap = {};
  @Input()
  void set nounMetaMap(Map<String, dynamic> singleLangMeta) {
    if (_nounMetaMap != singleLangMeta) {
      _nounMetaMap = singleLangMeta;
      initializeMe();
    }
  }
  Map<String, dynamic> get nounMetaMap => _nounMetaMap;

  void initializeMe() {
    _log.info("$runtimeType()::initMe():: nounMetaMap = ${nounMetaMap}");
    if (_nounDataMap == null || _nounDataMap.isEmpty || _nounMetaMap == null || _nounMetaMap.isEmpty) {
      _log.info("$runtimeType()::initializeMe()::--data inputs are null or empty!");
      return;
    }
    _log.info("$runtimeType()::initMe()::hasDeclensions == ${_nounMetaMap['hasDeclensions']}");
    _log.info("$runtimeType()::initMe()::declensions order...");
    decOrder = _nounMetaMap['declensionsOrderPreference'];

    if (_nounMetaMap.containsKey("hasDeclensions")) {
      _log.info("$runtimeType()::initMe()::metaMap.containsKey(hasDeclensions) = ${_nounMetaMap.containsKey('hasDeclensions')}");
      if (_nounMetaMap['hasDeclensions'] == true) {
        _log.info("DECLENSIONS == TRUE!!!");
      }

      _log.info("$runtimeType()::initMe()::_nounDataMap['masculine'] == ${_nounDataMap['masculine']}");
      _log.info("$runtimeType()::initMe()::_nounDataMap['masculine'][0] == ${_nounDataMap['masculine'][0]}");
//      _nounDataMap['masculine'][0].forEach((String decType, Map nvOtherMap) {
//        if (decType != 'type' && decType != 'word') { // don't add the example shits
//          declensionTypes.add(decType);
//          _log.info("$runtimeType()::initMe():: found declension type: $decType!");
//        }
//        mascList = _nounDataMap['masculine'];
//        femList = _nounDataMap['feminine'];
//
//        if (_nounDataMap.containsKey('neuter')) {
//          neutList = _nounDataMap['neuter'];
//          _log.info("$runtimeType()::initMe():: neutList = $neutList");
//        }
//      });
      _log.info("$runtimeType()::initMe()::mascList = $mascList");
      _log.info("$runtimeType()::initMe()::femList = $femList");
    }
    else {
      _log.info("$runtimeType()::initMe():: --No declensions for this language!");
    }
    /*** TEST ***/
//    mascList = _nounDataMap['masculine'];
//    _log.info("$runtimeType()::initMe()::mascList = $mascList");
////        _log.info("$runtimeType()::initMe()::mascMap = $mascMap");
////        femMap = _nounDataMap['feminine'];
//    femList = _nounDataMap['feminine'];
//    _log.info("$runtimeType()::initMe()::femList = $femList");
////        _log.info("$runtimeType()::initMe()::femMap = $femMap");
//    if (_nounDataMap.containsKey('neuter')) {
////          neutMap = _nounDataMap['neuter'];
//      neutList = _nounDataMap['neuter'];
//      _log.info("$runtimeType()::initMe():: neutList = $neutList");
////          _log.info("$runtimeType()::initMe():: neutMap = $neutMap");
//    }
    /*** TEST ***/
    _log.info("$runtimeType()::initializeMe()::--success!");
  }


} // end class NounView
