import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/views/noun_view/noun_view.dart';
import 'package:RSB/views/adjective_view/adjective_view.dart';
import 'package:RSB/views/vocab_view/vocab_view.dart';

@Component(
  selector: 'language-view',
  styleUrls: const ['language_view.css'],
  templateUrl: 'language_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives, NounView, AdjectiveView, VocabView],
  providers: const [materialProviders]
)
class LanguageView implements OnInit {
  final LoggerService _log;

  String _currentLang = "";
  Map _languageDataMap = {};
  Map _languageMetaMap = {};

  Map currentLangData = {};
  Map currentLangMeta = {};

  @Input()
  void set currentLang(String cl) {
    if (_currentLang != cl) {
      _currentLang = cl;
      _initMe();
    }
  }

  @Input()
  void set langDataMap(Map ldm) {
    if (_languageDataMap != ldm) {
      _languageDataMap = ldm;
      _initMe();
    }
  }
  Map get languageDataMap => _languageDataMap;

  @Input()
  void set langMetaMap(Map lmm) {
    if (_languageMetaMap != lmm) {
      _languageMetaMap = lmm;
      _initMe();
    }
  }
  Map get languageMetaMap => _languageMetaMap;


  void _initMe() {
    _log.info("$runtimeType::_initMe()");
    _log.info("$runtimeType::_initMe() -- _currentLang = $_currentLang");
    _log.info("$runtimeType::_initMe() -- _languageDataMap = $_languageDataMap");
    _log.info("$runtimeType::_initMe() -- _languageMetaMap = $_languageMetaMap");
    if (_currentLang != null && _currentLang.isNotEmpty) {
      if (_languageDataMap != null && _languageDataMap.isNotEmpty && _languageMetaMap != null && _languageMetaMap.isNotEmpty) {
        currentLangData = _languageDataMap[_currentLang];
        currentLangMeta = _languageMetaMap[_currentLang];
      }
    }
  }

  @override
  ngOnInit() {
   _log.info("$runtimeType::ngOnInit()");
  }

  LanguageView(LoggerService this._log) {
    _log.info("$runtimeType");
  }

}