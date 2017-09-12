//import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/models/learner.dart';

@Injectable()
class FirebaseService {// implements OnInit {
  static const String USER_META = "usermeta";
  static const String USER_DATA = "userdata";
  static const String VOCAB_LISTS = "vocabLists";

  final LoggerService _log;

  firebase.Auth _fbAuth;
  firebase.GoogleAuthProvider _fbGoogleAuthProvider;
  firebase.Database _fbDatabase; // = firebase.database();
//  firebase.Storage _fbStorage;
  firebase.DatabaseReference fbUserData;
  firebase.DatabaseReference fbUserMeta; // = database.ref("test");
  firebase.DatabaseReference fbSingUserData;
//  firebase.DatabaseReference fbSingUserMeta; // = database.ref("test");
  firebase.DatabaseReference fbLangList; // = database.ref("test");
  firebase.DatabaseReference fbLangData;
  firebase.DatabaseReference fbLangMeta;
  firebase.DatabaseReference fbVocabListData;
  firebase.DatabaseReference fbVocabListMeta;
  firebase.DatabaseReference fbSingleUserVocabList;
//  firebase.StorageReference userStorage; // Unnecessary?

  firebase.User fbUser;
  Learner learner;

  /* Users info */
  Map _userDataMap = {};
  Map _singleUserData = {};

  /* Languages info */
  String selectedLanguage = "";
  Map<String, String> vocabMeta = {};
  Map<String, Map<String, Map<String, String>>> allUsersVocabLists = {};
  Map<String, Map<String, String>> singleUsersVocabLists = {};
//  bool hasLanguage = false;
//  Map tempData = {};
  Map allLanguageMeta = {};
  Map singleLangMeta = {};
  List<String> languages = [];
  Map<String,Map<String, Map<String, Map<String, dynamic>>>> allLanguageData = {};

  Map<String, Map<String, Map<String, dynamic>>> singleLangData = {};

  FirebaseService(LoggerService this._log) {
    _log.info("$runtimeType()::defaultConstructor()");
    firebase.initializeApp(
        apiKey: "AIzaSyDSWfGxdhpUUIkDQiIkb0xtK-IFfIYrMFQ",
        authDomain: "langstudbud.firebaseapp.com",
        databaseURL: "https://langstudbud.firebaseio.com",
        storageBucket: "gs://langstudbud.appspot.com/"
    );

    _fbGoogleAuthProvider = new firebase.GoogleAuthProvider();
    _fbAuth = firebase.auth();
    _fbAuth.onAuthStateChanged.listen(_authChanged);
    _fbDatabase = firebase.database();
    fbUserMeta = _fbDatabase.ref("usermeta");
    fbUserData = _fbDatabase.ref("userdata");
    fbLangList = _fbDatabase.ref("languagesList");
    fbLangData = _fbDatabase.ref("languagesData");
    fbLangMeta = _fbDatabase.ref("languagesMeta");
//    fbVocabListData = _fbDatabase.ref("vocabLists");
    fbVocabListMeta = _fbDatabase.ref("vocabMeta");
//    fbStorageRoot = _fbStorage.ref("/");  // Unnecessary?

    fbLangList.onValue.listen((firebase.QueryEvent lList) async {
      _log.info("$runtimeType()::defaultConstructor()::lList.runtimeType = ${lList.snapshot.val().runtimeType}");
      languages = await lList.snapshot.val();
      _log.info("$runtimeType()::defaultConstructor()::language list: ${languages}");
    });


    fbLangMeta.onChildAdded.listen((firebase.QueryEvent lMeta) async {
      allLanguageMeta = await lMeta.snapshot.val();
      _log.info("$runtimeType()::defaultConstructor()::allLangMeta: ${allLanguageMeta.toString()}");
    });

    fbUserData.onValue.listen((firebase.QueryEvent uData) async {
      _userDataMap = await uData.snapshot.val();
      _log.info("$runtimeType()::defaultConstructor()::user data: ${_userDataMap.toString()}");
    });

    fbLangData.onChildAdded.listen((firebase.QueryEvent lData) async {
      allLanguageData = await lData.snapshot.val();
      _log.info("$runtimeType()::defaultConstructor()::allLangData: ${allLanguageData.toString()}");
    });

    fbVocabListMeta.onValue.listen((firebase.QueryEvent vMeta) async {
//      vocabMeta = await vMeta.snapshot.val();
      vocabMeta = await vMeta.snapshot.val();
      _log.info("$runtimeType()::defaultConstructor()::vocabMeta: ${vocabMeta.toString()}");
    });

  } // end Firebase default constructor


  Future<bool>  isUserInDatabase(String userID) async {
    _log.info("$runtimeType()::isUserInDatabase()");
    bool isUserInDB = false;
    if (_userDataMap == null || _userDataMap.isEmpty) {
      fbUserMeta.onValue.listen((firebase.QueryEvent e) async {
        if (e.snapshot.exists()) {
          _userDataMap = await e.snapshot.val();
          _log.info("$runtimeType()::_userMetaMap.onChildAdded.listen::${e.snapshot.val().toString()}");
        }
      });
    }
    if (_userDataMap.containsKey(userID)) {
      _log.info("$runtimeType()::isUserInDatabase():: -- true");
      isUserInDB = true;
    }
    else {
      _log.info("$runtimeType()::isUserInDatabase():: -- false");
    }
    return isUserInDB;
  }

  Future<Map> getUserMeta() async {
    _log.info("$runtimeType()::getUserMeta()");
    if (_userDataMap == null || _userDataMap.isEmpty) {
      ///todo: Are two async calls necessary?
      fbUserMeta.onValue.listen((firebase.QueryEvent e) async {
        _log.info("$runtimeType()::getUserMeta():: e.snapshot.val().runtimeType == ${e.snapshot.val().runtimeType}");
        _userDataMap = await e.snapshot.val();
      });
    }
    return _userDataMap;
  }



    Future<Map> getSingleUserData(String userID) async {
    _log.info("$runtimeType()::getSingleUserData()");
    String userDataPath = "$USER_DATA/$userID";
    try {
//      fbSingUserData = _fbDatabase.ref("$USER_DATA/$userID");
      fbSingUserData = _fbDatabase.ref(userDataPath);
      fbSingUserData.onValue.listen((firebase.QueryEvent e) async {
        _log.info("$runtimeType()::getSingleUserData():: e.snapshot.val().runtimeType == ${e.snapshot.val().runtimeType}");
        _singleUserData = await e.snapshot.val();
      });
    }
    catch (er) {
      _log.info("$runtimeType()::getSingleUserData()::error -- $er");
      _log.info("$runtimeType()::getSingleUserData()::userData not present in database!");
      _singleUserData = {};
    }
    return _singleUserData;
  }


  Future<Map<String, Map<String, String>>> getAllLangMeta() async {
    _log.info("$runtimeType()::getAllLangMeta()");
    if (allLanguageMeta == null || allLanguageMeta.isEmpty) {
      fbLangMeta.onValue.listen((firebase.QueryEvent e) async {
        allLanguageMeta = await e.snapshot.val();
        _log.info("$runtimeType()::getAllLangMeta():: e.snapshot.val().runtimeType == ${e.snapshot.val().runtimeType}");
        _log.info("$runtimeType()::languageMeta.onChildAdded.listen::${e.snapshot.val()}");
      });
    }
    return allLanguageMeta;
  }

  Future<Map<String, dynamic>> getSingleLangMeta([String lang = ""]) async {
    // async {
    _log.info("$runtimeType()::getSingleLangMeta($lang)");
//    if (lang != "") {
    if (allLanguageMeta != null && allLanguageMeta.isNotEmpty) {
      singleLangMeta = allLanguageMeta[lang];
    }
    else {
      fbLangMeta.onValue.listen((firebase.QueryEvent e) async {
        _log.info("$runtimeType()::getSingleLangDMeta():: e.snapshot.val().runtimeType == ${e.snapshot.val().runtimeType}");
        allLanguageMeta = await e.snapshot.val();
        _log.info("$runtimeType()::getSingleLangMeta():: allLangMeta = ${allLanguageMeta}");
        singleLangMeta = await allLanguageMeta[lang];
        _log.info("$runtimeType()::getSingleLangMeta()::singLangMeta = ${singleLangMeta}");
      });
    }
    return singleLangMeta;
//    }
//    else { // No language was passed in, what the fuck.
//      return {
//        "hasDeclensions": false,
//        "hasConjugations":false,
//        "hasGender": false
//      };
//    }
  }

  Future<Map<String,Map<String, Map<String, Map<String, dynamic>>>>> getAllLangData() async {
    _log.info("$runtimeType()::getAllLangData()");
    if (allLanguageData == null || allLanguageData.isEmpty) {
      fbLangData.onValue.listen((firebase.QueryEvent e) async {
        _log.info("$runtimeType()::getAllLangData():: e.snapshot.val().runtimeType == ${e.snapshot.val().runtimeType}");
        allLanguageData = await e.snapshot.val();
        _log.info("$runtimeType()::fullLanguageData::${allLanguageData}");
      });
    }
    return allLanguageData;
  }

  Future<Map<String, Map<String, Map<String, dynamic>>>> getSingleLangData([String lang = ""]) async {
    _log.info("$runtimeType()::getSingleLangData($lang)");
    if (lang != "") {
      if (allLanguageData != null && allLanguageData.isNotEmpty) {
        singleLangData = allLanguageData[lang];
      }
      else {
        fbLangData.onValue.listen((firebase.QueryEvent e) async {
          _log.info("$runtimeType()::getSingleLangData():: e.snapshot.val().runtimeType == ${e.snapshot.val().runtimeType}");
          allLanguageData = await e.snapshot.val();
          singleLangData = await allLanguageData[lang];
          _log.info("$runtimeType()::getSingleLangData()::singleLangData = ${singleLangData}");
        });
      }
      return singleLangData;
    }
    else {
      _log.info("$runtimeType()::getSingleLangData():: -- it's fuckin' empty!!!");
      return {};
    }
  }

  Future<List<String>> getLangList() async {
    _log.info("$runtimeType()::getLangList()");
    if (languages.isNotEmpty) {
      _log.info("$runtimeType()::getLangList()::language list is populated!");
      _log.info("$runtimeType()::getLangList()::languages are: ${languages}");
      return languages;
    }
    else {
      _log.info("$runtimeType()::getLangList()::language list is being populated...");
      fbLangList.onValue.listen((firebase.QueryEvent e) async {
        languages = await e.snapshot.val();
//        _log.info("$runtimeType()::getLangList()::e.snapshot.val().runtimeType == ${e.snapshot.val().runtimeType}");
//        _log.info("$runtimeType()::getLangList()::languages.runtimeType == ${languages.runtimeType}");
//        _log.info("$runtimeType()::languages::${languages}");
      });
      return languages;
    }
  }

//  // I think this will not be used.
//  Future<firebase.StorageReference> getUserStorage(String userID) async {
//    _log.info("$runtimeType()::getUserStorage()");
////    if (_userMetaMap.containsKey(userID) ) {
//    bool isThere = await isUserInDatabase(userID);
//    if (isThere) { // == true)  {
//      _log.info("$userID exists as user storage!");
//    }
//    else {
//      _log.info("$userID does not already exist in storage. Will this create a new bucket?");
//    }
//    ///todo: Will this create a new storage bucket for user if not present?
//    userStorage = await _fbStorage.ref("/$userID");
//
//    return userStorage;
//  }

  Future<Map<String, String>> getVocabMeta() async {
    _log.info("$runtimeType()::getVocabMeta()");
    if (vocabMeta == null || vocabMeta.isEmpty) {
      fbVocabListMeta.onChildAdded.listen((firebase.QueryEvent e) async {
        vocabMeta = await e.snapshot.val();
      });
    }
    return vocabMeta;
  }

  Future<Map<String,Map<String,String>>> getVocabLists(String userID) async {
    _log.info("$runtimeType()::getVocabLists");
    if (singleUsersVocabLists == null || singleUsersVocabLists.isEmpty) {
      fbVocabListData = _fbDatabase.ref("$VOCAB_LISTS/$userID");
      fbVocabListData.onValue.listen((firebase.QueryEvent e) async {
        singleUsersVocabLists = await e.snapshot.val();
        _log.info("$runtimeType()::getVocabLists():: e.snapshot.val().runtimeType: ${e.snapshot.val().runtimeType}");
        learner.vocabLists = singleUsersVocabLists;
        _log.info("$runtimeType()::learner.vocabLists = ${learner?.vocabLists}");
      });
    }
    return singleUsersVocabLists;
  }



  Future<Map<String, String>> getVocabListForLang([String userID, String lang]) async {
    _log.info("$runtimeType()::getSingleVocabList($userID, $lang)");
    _log.info("$runtimeType()::getSingleVocabList()::learner.hasVocab == ${learner.hasVocabLists}");
    if (userID == null) {
      _log.info("$runtimeType()::getSingleVocabList()::userID == $userID");
      return {"no_user": "provided"};
    }
    if (lang == null || lang.isEmpty) {
      _log.info("$runtimeType()::getSingleVocabList()::lang == $lang");
      return {"no_language": "provided"};
    }
    if (learner.hasVocabLists == true) { // They have vocab. Do they have it for THIS language though?
      if (singleUsersVocabLists == null || singleUsersVocabLists.isEmpty) { // User's vocab lists haven't been built yet.
        _log.info("$runtimeType()::getSingleVocabList()::my vocab lists = ${learner.vocabLists}");
        getVocabLists(userID);
        return singleUsersVocabLists[lang];
      }
      else { // singleUsersVocabLists exists.
        _log.info("$runtimeType()::getSingleVocabList():: vocab list for $lang = ${learner.getVocabListForLang(lang)}");
        return singleUsersVocabLists.containsKey(lang) ? singleUsersVocabLists[lang] : {"user has vocab lists": "but not for this language"};
      }
    }
    else { // User does not have vocab lists.
      return {"you_have_no": "vocab_lists!"};
    }
  }

  Future<Null> updateVocabLists(String userID, String lang) async {
    String refToLang = "$VOCAB_LISTS/$userID/$lang";
    _log.info("$runtimeType()::updateVocabLists($refToLang)");
    fbSingleUserVocabList = _fbDatabase.ref(refToLang);
    if (learner.currentVocabList != null && learner.currentVocabList.isNotEmpty) {
      fbSingleUserVocabList.update(learner.currentVocabList);
    }
  }

  Future<List<String>> getUserLangList([String userID]) async {
    _log.info("$runtimeType()::getUserLangList()");
    if (learner?.myLanguages == null || learner.myLanguages.isEmpty) {
      if (_singleUserData == null || _singleUserData.isEmpty) {
        if (learner.uid != null && learner.uid.isNotEmpty) {
          await getSingleUserData(learner.uid);
        }
        else {
          await getSingleUserData(userID);
        }
      }
      else {
        learner.myLanguages = _singleUserData['myLanguages'];
      }
    }
    return learner.myLanguages;
  }

  Future<String> getSelectedLanguage() async {
    _log.info("$runtimeType()::getSelectedLanguage()");
    _log.info("$runtimeType()::getSelectedLanguage() --selectedLanguage = $selectedLanguage");
//    _log.info("$runtimeType()::getSelectedLanguage() --learner.currentLanguage = ${learner?.currentLanguage}");
    _log.info("$runtimeType()::getSelectedLanguage() --languages = $languages");
    if (selectedLanguage == null || selectedLanguage.isEmpty) {
      if (learner?.currentLanguage == null || learner.currentLanguage.isEmpty) {
        if (languages == null || languages.isEmpty) {
          getLangList().then((f) {
            languages = f;
            selectedLanguage = languages?.first;
          });
        }
        else {
          selectedLanguage = languages?.first;
        }
      }
      else {
        selectedLanguage = learner?.currentLanguage;
      }
    }
    return selectedLanguage;
  }

  Future<Null> completeLearner() async {
    _log.info("$runtimeType()::completeLearner()");
    if (learner == null) {
      _log.info("$runtimeType()::completeLearner()::learner is null!");
      getSingleUserData(fbUser.uid);

      _log.info("$runtimeType()::completeLearner()::singleUserData for ${fbUser.uid} is $_singleUserData");
      learner = new Learner.fromMap(_log, _singleUserData);
    }
    else {
      try {
        _log.info("$runtimeType()::completeLearner()::learner is not null, attempting new Learner.fromMap!");
        getSingleUserData(fbUser.uid);
         learner = new Learner.fromMap(_log, _singleUserData);
        getSingleUserData(fbUser.uid);
        getVocabLists(fbUser.uid);
      }
      catch (e) {
        _log.info("$runtimeType()::completeLearner():: Error: $e");
      }
    }
  }

  _authChanged(firebase.User newUser) async {
    _log.info("$runtimeType()::_authChanged()");
    fbUser = newUser;
    _log.info("$runtimeType()::_authChanged()::fbUser = newUser: ${fbUser.toString()} = ${newUser.toString()}");
    if (newUser != null) { // newUser will be null on a logout()
      String userDataPath;
      userDataPath = "$USER_DATA/${newUser.uid}";
      _log.info("$runtimeType()::_authChanged()::userData map: ${_userDataMap}");
//      await getSingleUserData(newUser.uid);
//      fbSingUserData = _fbDatabase.ref("$USER_DATA/$userID");
        fbSingUserData = _fbDatabase.ref(userDataPath);
        fbSingUserData.onValue.listen((firebase.QueryEvent e) async {
          _log.info("$runtimeType()::getting SingleUserData:: e.snapshot.val().runtimeType == ${e.snapshot.val().runtimeType}");
          _singleUserData = await e.snapshot.val();
        });
      _log.info("$runtimeType()::_authChanged()::new Learner.fromMap(getSingleUserData(${newUser.uid})");
      learner = new Learner.fromMap(_log, _singleUserData);
//      learner = new Learner.fromMap(_log, getSingleUserData(newUser.uid));
      fbVocabListData = _fbDatabase.ref("$VOCAB_LISTS/${newUser.uid}");
      fbVocabListData.onValue.listen((firebase.QueryEvent e) async {
        learner.vocabLists = await e.snapshot.val();
        _log.info("$runtimeType()::_authChanged():: e.snapshot.val.runtimeType == ${e.snapshot.val().runtimeType}");
        _log.info("$runtimeType()::_authChanged():: e == ${e.snapshot.val()}");
      });
      _log.info("$runtimeType()::_authChanged()::learner = ${learner}");
      _log.info("$runtimeType()::_authChanged():: _userDataMap = ${_userDataMap}");
//      _log.info("$runtimeType()::_authChanged():: _userDataMap.toString() = ${_userDataMap.toString()}");
      _log.info("$runtimeType()::_authChanged():: _userDataMap.containsKey(${newUser.uid}) == ${_userDataMap.containsKey(newUser.uid)}");
    }
    getSelectedLanguage();
  } // end _authChanged

  Future signIn() async {
    try {
      await _fbAuth.signInWithPopup(_fbGoogleAuthProvider);
      _log.info("$runtimeType::login() -- logging in...");
    }
    catch (error) {
      _log.info("$runtimeType::login() -- $error");
    }
  }

  void signOut() {
    _log.info("$runtimeType::logout()");
    _fbAuth.signOut();
  }

  Future<Null> changeLang(String lang) async {
    _log.info("$runtimeType()::changeLang($lang)");
    if (selectedLanguage != null && selectedLanguage.isEmpty) { // First time picking; easy.
      // Set current language to the selected language.
      selectedLanguage = lang;
      // Get language metadata
      singleLangMeta = await getSingleLangMeta(lang);

      // Get the language data for the selected language.
      singleLangData = await getSingleLangData(lang);
      learner.changeLang(lang); // This should handle all cases I care about...
    }
  }

  Future<Null> addWord(String newWord, [String def = ""]) async {
    learner.vocabLists[selectedLanguage][newWord] = def;
    await fbVocabListData.update(learner.vocabLists);
  }

  Future<Null> removeWord(String oldWord) async {
    learner.vocabLists[selectedLanguage].remove(oldWord);
    await fbVocabListData.update(learner.vocabLists);
  }

} //end class FirebaseService

