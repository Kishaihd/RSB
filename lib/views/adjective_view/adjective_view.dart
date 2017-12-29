//import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
//import '../../services/noun_service.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';

///todo: restructure tables as adjectives rather than like nouns.

@Component(
  selector: 'adj-view',
  styleUrls: const ['adjective_view.css'],
  templateUrl: 'adjective_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders]//, LoggerService],
)
class AdjectiveView { //implements OnInit {
  final LoggerService _log;
//  final FirebaseService fbService;

  List<String> views = const [
    "referenceView",
    "notesView"
  ];
  String currentView = "";

  //  Map<String, List<Map<String, dynamic>>> masterMap; // the dynamic is either string or a map.
//Map<gender, Map<example index, Map<case, Map<sing_or_plurl, word>>>  OR
//Map<gender, Map<index, Map<type/word, desc/example>>>

//  List<Map> mascList = [];
  List<String> decOrder = [];
  List<String> genders = [];
  Map adjMap = {};

  // Each idx is another example.
  //List<ExampleMap<
//  List<Map<>>

  Map _langDataMap = {};
  @Input()
  void set langDataMap(Map ldm) {

    _log.info("$runtimeType::set langDataMap()::ldm = $ldm");
    if (_langDataMap != ldm) {
      _langDataMap = ldm;
      _initMe();
    }
  }

  Map _langMetaMap = {};
  @Input()
  void set langMetaMap(Map lmm) {
    _log.info("$runtimeType::set langMetaMap()::lmm = $lmm");
    if (_langMetaMap != lmm) {
      _langMetaMap = lmm;
      _initMe();
    }
  }
  Map get langMetaMap => _langMetaMap;

  void _initMe() {
    _log.info("$runtimeType::_initMe()");
//    _log.info("$runtimeType::_initMe()::_langDataMap = $_langDataMap");
//    _log.info("$runtimeType::_initMe()::_langMetaMap['hasDeclensions'] = ${_langMetaMap['hasDeclensions']}");
//    _log.info("$runtimeType::_initMe()::_langMetaMap['hasDeclensions'].runtimeType = ${_langMetaMap['hasDeclensions'].runtimeType}");
    if (_langDataMap != null) {
      if (_langMetaMap != null) {
        adjMap = _langDataMap['adjectives'];
        if (_langMetaMap['hasDeclensions'] == 'true') {
          decOrder = _langMetaMap['declensionsOrderPreference'];
        }
        if (_langMetaMap['hasGender'] == 'true') {
          genders = _langMetaMap['genders'];
        }
      }
    }
  }
  AdjectiveView(LoggerService this._log) {
    _log.info("$runtimeType");
    currentView = views.elementAt(0); // 0th index should be first view.
  }

  //  void set adjDataMap(Map<String, Map<String, Map<String, dynamic>>> singleLangData) {
//  @Input()
//  void set adjDataMap(Map singleLangData) {
//    _log.info("$runtimeType()::@Input set adjDataMap()");
//    if (singleLangData.containsKey('adjectives')) {
//      _log.info("$runtimeType()::set adjDataMap() --contains key 'adjectives' ");
//      if (_adjDataMap != singleLangData["adjectives"]) {
//        _adjDataMap = singleLangData["adjectives"];
//        initializeMe();
//      }
//    }
//    else {
//      _log.info("$runtimeType()::@Input() set adjDataMap():: -- key 'adjectives' not found!");
//    }
//  }
////  Map<String, Map<String, Map<String, dynamic>>>
//  Map get adjDataMap => adjMap;

//  Map<String, dynamic> _adjMetaMap = {};
//  @Input()
//  void set adjMetaMap(Map<String, dynamic> singleLangMeta) {
//    if (_adjMetaMap != singleLangMeta) {
//      _adjMetaMap = singleLangMeta;
//      initializeMe();
//    }
//  }
//  Map<String, dynamic> get adjMetaMap => _adjMetaMap;

//  @override
//  ngOnInit() async {
//    if (_adjDataMap == null || _adjDataMap.isEmpty) {
//      fbService.getSingleLangData(await fbService.getSelectedLanguage()).then((lDat) {
//        _adjDataMap = lDat['adjectives'];
//        _log.info("$runtimeType()::ngOnInit():: adjDataMap = ${_adjDataMap}");
//        if (_adjDataMap.containsKey('masculine')) {
//          mascList = _adjDataMap['masculine'];
//          _log.info("$runtimeType()::initMe()::mascList = $mascList");
//        }
//        if (_adjDataMap.containsKey('feminine')) {
//          femList = _adjDataMap['feminine'];
//          _log.info("$runtimeType()::initMe()::femList = $femList");
//        }
//        if (_adjDataMap.containsKey('neuter')) {
//          neutList = _adjDataMap['neuter'];
//          _log.info("$runtimeType()::initMe():: neutList = $neutList");
//        }
//      });
//    }
//
//    if (_adjMetaMap == null || _adjMetaMap.isEmpty) {
//      fbService.getSingleLangMeta(await fbService.getSelectedLanguage()).then((lMet) {
//        _adjMetaMap = lMet;
//      });
//    }
//  }

//  initializeMe() async {
//    _log.info("$runtimeType()::initMe():: _adjMetaMap = ${_adjMetaMap}");
//    _log.info("$runtimeType()::initMe():: adjMetaMap = ${adjMetaMap}");
//    if (_adjDataMap == null || _adjMetaMap == null) {
//
//    }
//    _log.info("$runtimeType()::initMe()::hasDeclensions == ${_adjMetaMap['hasDeclensions']}");
//    _log.info("$runtimeType()::initMe()::declensions order...");
//    decOrder = _adjMetaMap['declensionsOrderPreference'];
////    if (_adjMetaMap['hasDeclensions'] == true) {
//    if (_adjMetaMap.containsKey("hasDeclensions")) {
//      _log.info("$runtimeType()::initMe()::metaMap.containsKey(hasDeclensions) = ${_adjMetaMap.containsKey('hasDeclensions')}");
//      if (_adjMetaMap['hasDeclensions'] == true) {
//        _log.info("DECLENSIONS == TRUE!!!");
//      }
////      _log.info("$runtimeType()::initMe()::adjDataMap = ${_adjDataMap}");
////      _log.info("$runtimeType()::initMe()::adjDataMap['masculine'] = ${_adjDataMap['masculine']}");
////      _log.info("$runtimeType()::initMe()::adjDataMap['feminine'] = ${_adjDataMap['feminine']}");
////      _log.info("$runtimeType()::initMe()::adjDataMap['neuter'] = ${_adjDataMap['neuter']}");
////      _adjDataMap['masculine'][0].forEach((String decType, Map other) {
////        if (decType != 'type' && decType != 'word') { // don't add the example shits
////          declensionTypes.add(decType);
////          _log.info("$runtimeType()::initMe():: found declension type: $decType!");
////        }
//////        mascMap = _adjDataMap['masculine'];
////        mascList = _adjDataMap['masculine'];
////        _log.info("$runtimeType()::initMe()::mascList = $mascList");
//////        _log.info("$runtimeType()::initMe()::mascMap = $mascMap");
//////        femMap = _adjDataMap['feminine'];
////        femList = _adjDataMap['feminine'];
////        _log.info("$runtimeType()::initMe()::femList = $femList");
//////        _log.info("$runtimeType()::initMe()::femMap = $femMap");
////        if (_adjDataMap.containsKey('neuter')) {
//////          neutMap = _adjDataMap['neuter'];
////          neutList = _adjDataMap['neuter'];
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
//    /*** TEST ***/
////    mascList = _adjDataMap['masculine'];
////    _log.info("$runtimeType()::initMe()::mascList = $mascList");
//////        _log.info("$runtimeType()::initMe()::mascMap = $mascMap");
//////        femMap = _adjDataMap['feminine'];
////    femList = _adjDataMap['feminine'];
////    _log.info("$runtimeType()::initMe()::femList = $femList");
//////        _log.info("$runtimeType()::initMe()::femMap = $femMap");
////    if (_adjDataMap.containsKey('neuter')) {
//////          neutMap = _adjDataMap['neuter'];
////      neutList = _adjDataMap['neuter'];
////      _log.info("$runtimeType()::initMe():: neutList = $neutList");
//////          _log.info("$runtimeType()::initMe():: neutMap = $neutMap");
////    }
//    /*** TEST ***/
//    _log.info("$runtimeType()::initializeMe()::--success?");
//  }


} // end class NounView

