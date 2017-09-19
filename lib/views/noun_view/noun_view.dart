
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:newRSB/services/logger_service.dart';

@Component(
  selector: 'noun-view',
  styleUrls: const ['noun_view.css'],
  templateUrl: 'noun_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders]
)
class NounView { //implements OnInit {
  LoggerService _log;

  List<String> views = const [
    "referenceView",
    "notesView"
  ];
  String currentView = "";

  List<String> decOrder = [];
  List<String> genders = [];
  Map nounMap = {};
  Map _langMetaMap = {};

  Map _langDataMap = {};
  @Input()
  void set langDataMap(Map ldm) {
    _log.info("$runtimeType::set langDataMap()::ldm = $ldm");
    if (_langDataMap != ldm) {
      _langDataMap = ldm;
      _initMe();
    }
  }
//  Map get nounDataMap => _languageDataMap;

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
        nounMap = _langDataMap['nouns'];
        if (_langMetaMap['hasDeclensions'] == 'true') {
          decOrder = _langMetaMap['declensionsOrderPreference'];
        }
        if (_langMetaMap['hasGender'] == 'true') {
          genders = _langMetaMap['genders'];
        }
      }
    }
  }

//  @override
//  ngOnInit() {
//
//  }

  NounView(LoggerService this._log) {
    _log.info("$runtimeType");
    currentView = views[0];
  }
}