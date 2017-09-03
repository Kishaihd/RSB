//import 'package:RSB/services/firebase_service.dart' as firebase;
//import 'dart:async';
import 'package:RSB/services/logger_service.dart';

class Learner {
  final LoggerService _log;

  // User info
  String _name = "";
  String _email = "";
  String _uid = "";
//  bool _exists = false; // Exists in database
  bool hasLanguages = false;
//  bool isComplete = false; // Has at least one language added to their ref sheet.
  bool hasVocabLists = false; // May just be using app for reference!

  // Language info
//  int _numLanguages = 0; // Does this matter? Probably not.
  Map tempLangList = {};
  Map<String, Map<String, String>> allLanguagesMeta = {};
  Map<String, String> singleLanguageMeta = {};
  List<String> myLanguages = [];
  String currentLanguage = "";
  Map<String, String> currentVocabList = {}; // Local.

  // Custom vocabulary list creatable by the user.
  // Map<LanguageName, Map<word, definition>>
  Map<String, Map<String, String>> _myVocabLists = {};

  // Default Constructor
  Learner(LoggerService this._log, String newUid, String newName, String newEmail, [List<String> langList, String newCurrentLang, bool hasVoc]) {
    _log.info("$runtimeType()::defaultConstructor");

    _log.info("$runtimeType()::defaultConstructor()::uid = ${newUid}");
    _log.info("$runtimeType()::defaultConstructor()::name = ${newName}");
    _log.info("$runtimeType()::defaultConstructor()::email = ${newEmail}");
    _log.info("$runtimeType()::defaultConstructor()::myLanguages = ${langList}");
    _log.info("$runtimeType()::defaultConstructor()::currentLanguage = ${newCurrentLang}");
    _log.info("$runtimeType()::defaultConstructor()::hasVocabLists = ${hasVoc}");
    checkComplete();
  }


  // Old .fromMap constructor.
  Learner.fromMap(LoggerService _log, Map map) : this(_log, map["uid"], map["name"], map["email"], map["myLanguages"], map["currentLanguage"], map["hasVocabLists"]);


    Map toMap() {
      _log.info("$runtimeType()::toMap()");
      return {
        "uid": _uid,
        "name": _name,
        "email": _email,
        "myLanguages": myLanguages.asMap(),
        "currentLanguage": currentLanguage,
        "hasVocabLists": hasVocabLists,
      };
    }

    bool checkComplete() {
      if (myLanguages == null || myLanguages.isEmpty || _name.isEmpty || _uid.isEmpty) {
//      isComplete = true;
        return false;
      }
      else {
        return true;
      }
    }

    void changeLang(String newLang) {
      if (currentVocabList != null && currentVocabList.isNotEmpty) {
        currentVocabList.forEach((String word, String def) {
          //      vocabLists[currentLanguage].putIfAbsent(word, () => def);
          _myVocabLists[currentLanguage][word] = def; // Same?
        });
      }
//    // Does this do the above?
//    vocabLists[currentLanguage] = currentVocabList;
      currentLanguage = newLang;
      currentVocabList = _myVocabLists[newLang];
    }

    void addWord(String newWord, [String newDef = ""]) {
      currentVocabList[newWord] = newDef;
      hasVocabLists = true;
    }

    void removeWord(String oldWord) {
      currentVocabList.remove(oldWord);
    }

    void addLanguage(String language) {
      myLanguages.add(language);
      currentLanguage = language;
      hasLanguages = true;
    }

    void removeLanguage(String language) {
      myLanguages.remove(language);
      if (myLanguages.isEmpty) {
        currentLanguage = "";
        hasLanguages = false;
        hasVocabLists = false;
      }
    }

    String get  name => _name;
    String get email => _email;
    String get uid => _uid;
//  int get numLanguages => myLanguages.
    Map<String, String> getVocabListForLang(String lang) {
      return _myVocabLists[lang];
    }
    Map<String, Map<String, String>> get vocabLists => _myVocabLists;
//  }
  void set vocabLists(Map<String, Map<String, String>> allVocabLists) {
    _myVocabLists = allVocabLists;
    if (_myVocabLists.isNotEmpty) {
      hasVocabLists = true;
    }
  }

  void addVocabListForLang(Map newVocabList, String lang) {
    if (_myVocabLists.containsKey(lang)) {
      _myVocabLists[lang].addAll(newVocabList);
    }
    else {
      _myVocabLists[lang] = newVocabList;
    }
    hasVocabLists = true;
  }
//
//  // Custom vocabulary list creatable by the user.
//  // Map<LanguageName, Map<word, definition>>
//  Map<String, Map<String, String>> _myVocabLists = {};
//
//  Map tempLangList = {};
//  List<String> myLanguages = [];
//  String currentLanguage = "";
//  Map<String, String> currentVocabList = {};

}