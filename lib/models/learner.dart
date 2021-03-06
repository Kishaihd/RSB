//import 'package:RSB/services/firebase_service.dart' as firebase;
import 'dart:async';
import 'package:RSB/services/logger_service.dart';

class Learner {
  final LoggerService _log;

  // User info
  String _name = "";
  String _email = "";
  String _uid = "";
  bool _exists = false; // Exists in database
  bool hasLanguages = false;
  bool isComplete = false;
  bool hasVocab = false; // May just be using app for reference!

  // Language info
//  int _numLanguages = 0; // Does this matter? Probably not.
  Map tempLangList = {};
  Map<String, Map<String, String>> allLanguagesMeta = {};
  Map<String, String> singleLanguageMeta = {};
//  bool hasDec = false;
//  bool hasConj = false;
//  bool hasGender = false;
  List<String> myLanguages = [];
  String currentLanguage = "";
  Map<String, String> currentVocabList = {}; // Local.

  // Custom vocabulary list creatable by the user.
  // Map<LanguageName, Map<word, definition>>
  Map<String, Map<String, String>> _myVocabLists = {}; // This should go in a storage bucket!

  // Default Constructor
  Learner(LoggerService this._log) {
    _log.info("$runtimeType()::defaultConstructor");
    checkComplete();
  }

  // This should only be called the first time a user logs in after being added to the database.
  Learner.constructNewLearner(this._log, String uid, String newName, String newEmail, [Map langList, Map langMeta, String newCurrentLang, Map<String, Map<String, String>> vocabLists]) {
    _log.info("$runtimeType()::constructNewLearner()");
    _exists = true;
    _uid = uid;
    _name = newName;
    _email = newEmail;
    if (langMeta != null && langMeta.isNotEmpty) {
      allLanguagesMeta = langMeta;
      hasLanguages = true;
    }
    if (langList != null && langList.isNotEmpty) {
      hasLanguages = true;
      langList.forEach((String idx, String language) {
        myLanguages.add(language);
      });
      if (newCurrentLang != null && newCurrentLang.isNotEmpty) {
        currentLanguage = newCurrentLang;
      }
      else {
        currentLanguage = myLanguages[0];
      }
      singleLanguageMeta = allLanguagesMeta[currentLanguage];
      if (vocabLists != null && vocabLists.isNotEmpty) {
        _myVocabLists = vocabLists;
      }
    }
    checkComplete();
  }

  Learner.fromMap(LoggerService this._log, Map map) {
    _log.info("$runtimeType()::fromMap()${map.toString()}");
    _name = map["name"];
    _uid = map["uid"];
    _email = map["email"];
    _exists = true;
    ///todo: works, but should be restructured. Redundant.
    if (map["currentLanguage"].isEmpty) {
      if (map["myLanguages"].isNotEmpty) {
        currentLanguage = map["myLanguages"][0];
      }
      else {
        currentLanguage = map["currentLanguage"]; // SHOULD be ""
      }
    }
    else {
      currentLanguage = map["currentLanguage"];
    }
    if (map["myLanguages"].isNotEmpty) {
      hasLanguages = true;
      map["myLanguages"].forEach((String idx, String language) {
        myLanguages.add(language);
      });
    }
    if (map["myVocabLists"].isNotEmpty) {
      _myVocabLists = map["myVocabLists"];
    }
    checkComplete();
  } // End Learner.fromMap()

  Map toMap() {
    _log.info("$runtimeType()::toMap()");
    return {
      "uid": _uid,
      "name": _name,
      "email": _email,
      "exists": _exists,
      "currentLanguage": currentLanguage,
      "myVocabLists": _myVocabLists,
      "myLanguages": myLanguages.asMap()
    };
  }


  bool checkComplete() {
    if (myLanguages.isNotEmpty) {
      isComplete = true;
      return true;
    }
    else {
      return false;
    }
  }

  void changeLang(String newLang) {
    currentVocabList.forEach((String word, String def) {
//      vocabLists[currentLanguage].putIfAbsent(word, () => def);
      _myVocabLists[currentLanguage][word] = def; // Same?
    });
//    // Does this do the above?
//    vocabLists[currentLanguage] = currentVocabList;
    currentLanguage = newLang;
    currentVocabList = _myVocabLists[newLang];
  }

  void addWord(String newWord, [String newDef = ""]) {

    currentVocabList[newWord] = newDef;
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
  void set vocabLists(Map<String, Map<String, String>> allVocabLists) {
    _myVocabLists = allVocabLists;
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