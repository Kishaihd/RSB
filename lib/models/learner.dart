
import 'package:RSB/services/logger_service.dart';


class Learner {
  final LoggerService _log;

  // User info
  String _name = "";
  String _email = "";
  String _uid = "";
  bool existsInDB = false;
  bool _hasVocab = false;
  bool _hasLanguages = false;

  String get name => _name;
  String get email => _email;
  String get uid => _uid;
//  bool get existsInDB => _existsInDB;

  String currentLanguage = "";
  List<String> myLanguages = [];
  Map<String, Map<String, String>> vocabLists = {};
  Map<String, String> getVocabForLang(String lang) {
    if (vocabLists.containsKey(lang) == false) {
      vocabLists[lang] = {};
    }
    return vocabLists[lang];
  }


  Learner(LoggerService this._log, String newUID, String newName, String newEmail, [bool existance, List<String> newLangList, String newCurrentLang]) {
    _uid = newUID;
    _name = newName;
    _email = newEmail;
    if (existance != null) {
      existsInDB = existance;
    }
    else {
      existsInDB = false;
    }
    if (newLangList != null) {
      myLanguages = newLangList;
      if (newCurrentLang == null || newCurrentLang.isEmpty) {
        currentLanguage = myLanguages[0];
      }
      else {
        currentLanguage = newCurrentLang;
      }
    }
    else {
      myLanguages = [];
      currentLanguage = "";
    }

    _log.info("$runtimeType");
    _log.info("$runtimeType::uid: $newUID");
    _log.info("$runtimeType::name: $newName");
    _log.info("$runtimeType::email: $newEmail");
    _log.info("$runtimeType::exists in database: $existance");
    _log.info("$runtimeType::myLanguages: $newLangList");
    _log.info("$runtimeType::currentLanguage: $newCurrentLang");
//    _log.info("$runtimeType()::hasLanguages: $hasLangs");
//    _log.info("$runtimeType()::hasVocabLists: $hasVoc");
  }

  Learner.fromMap(LoggerService _log, Map map) :
      this(
        _log,
        map["uid"],
        map["name"],
        map["email"],
        map["existsInDB"],
        map["myLanguages"],
        map["currentLanguage"]
//        map["hasLanguages"],
//        map["hasVocabLists"]
      );

  Map toMap() {
    _log.info("$runtimeType");
    return {
      "uid": _uid,
      "name": _name,
      "email": _email,
      "existsInDB": existsInDB,
      "myLanguages": myLanguages,
      "currentLanguage": currentLanguage,
//      "hasVocabLists": _hasVocab,
//      "hasLanguages": _hasLanguages
    };
  }

//  @override
//  String toString() {
//    String userInfo;
//    userInfo = "\n${_uid}\n${_name}";
//    _log.info("$runtimeType::toString()::userInfo: $userInfo");
//    return userInfo;
//  }

  void addWord(String newWord, [String newDef = ""]) {
    vocabLists[currentLanguage][newWord] = newDef;
    _hasVocab = true;
  }

  void removeWord(String oldWord) {
    _log.info("$runtimeType::removeWord($oldWord)");
    vocabLists[currentLanguage].remove(oldWord);
    if (vocabLists.isEmpty) {
      _hasVocab = false;
    }
  }

  void addLanguage(String newLang) {
    _log.info("$runtimeType::addLanguage($newLang)");
    if (myLanguages.contains(newLang)) {
      _log.info("$runtimeType::addLanguage() --myLanguages already contains $newLang!");
      // Do nothing
    }
    else {
      _log.info("$runtimeType::addLanguage() --adding $newLang to list!");
      myLanguages.add(newLang);
    }
    _hasLanguages = true;
  }

  void switchLanguage(String newLang) {
    _log.info("$runtimeType::switchLanguage($newLang)");
    currentLanguage = newLang;
    _hasLanguages = true; // Just an assertion.
  }

  void removeLanguage(String oldLang) {
    _log.info("$runtimeType::removeLanguage($oldLang)");
    myLanguages.remove(oldLang);
    if (myLanguages.isEmpty) {
      _hasLanguages = false;
    }
  }

} // end Learner class