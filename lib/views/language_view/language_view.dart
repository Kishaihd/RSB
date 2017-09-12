import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';
//import '../../models/learner.dart';
import 'package:RSB/views/vocab_list_component/vocab_list_component.dart';
import 'package:RSB/views/vocab_view/vocab_view.dart';
import 'package:RSB/views/noun_view/noun_view.dart';
import 'package:RSB/views/verb_view/verb_view.dart';
import 'package:RSB/views/adjective_view/adjective_view.dart';

@Component(
  selector: 'language-view',
  styleUrls: const ['language_view.css'],
  templateUrl: 'language_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives, NounView, AdjectiveView, VerbView, VocabListComponent, VocabView],
  providers: const [materialProviders],
)
class LanguageView implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;


  String _lang = "";
//  @Input()
//  void set lang(String l) {
//    _log.info("$runtimeType()::set lang($l)");
//    if (l == null || l.isEmpty) {
//      l = fbService?.selectedLanguage;
//      _log.info("$runtimeType()::set lang($l) -- fbService.selectedLanguage = ${fbService.selectedLanguage}");
//    }
//    if (_lang != l) {
//      _lang = l;
//      _initMe();
//    }
//  }
  String get lang => _lang;



  ngOnInit() async {
    _log.info("$runtimeType()::ngOnInit()");
    _log.info("$runtimeType()::ngOnInit()::lang = $_lang");
//    if (_lang == null || _lang.isEmpty) {
//      _lang = await fbService.getSelectedLanguage();
      fbService.getSelectedLanguage().then((newLang) async {
        _lang = newLang;
        await fbService.getSingleLangMeta(lang);
        await fbService.getSingleLangData(lang);
      });
    _log.info("$runtimeType()::_initMe()::_lang is $_lang");
    _log.info("$runtimeType()::initMe()::--success!");
      return;
//    }
  }

//  @override
//  Future<Null> ngOnInit() async {
//    _log.info("$runtimeType()::ngOnInit()");
//    langData = await fbService.getSingleLangData(_lang);
//    _log.info("$runtimeType()::ngOnInit()::langData::${_langData.toString()}");
//    _langMeta = await fbService.getSingleLangMeta(_lang);
//    _log.info("$runtimeType()::ngOnInit()::langMeta::${_langMeta.toString()}");
//    nounData = _langData["nouns"];
//    _log.info("$runtimeType()::ngOnInit()::nounData::${_nounData.toString()}");
//    nounMeta = _langMeta[_lang];
//    _log.info("$runtimeType()::ngOnInit()::nounMeta::${_nounMeta.toString()}");
//
//    if (fbService.vocabMeta != null && fbService.vocabMeta.isNotEmpty) { // There may not be vocab lists.
//      if (fbService.vocabMeta.containsKey(fbService.learner.uid)) {
//        vocab = await fbService.getVocabLists(fbService.learner.uid);
//        _log.info("$runtimeType()::ngOnInit()::getVocab");
//      }
//    }
//
////    verbData = langData["verbs"];
//  }

  LanguageView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType()");
//    _initMe();
//    _lang = fbService.learner.currentLanguage ?? "nolang!";
//    _langMeta = fbService?.getSingleLangMeta(lang);
//    _langData = fbService?.getSingleLangData(lang);
  }

}
