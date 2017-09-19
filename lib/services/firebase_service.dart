import 'dart:async';
import 'package:angular/angular.dart';
import 'package:newRSB/services/logger_service.dart';
import 'package:newRSB/models/learner.dart';
import 'package:firebase/firebase.dart' as firebase;

@Injectable()
class FirebaseService {
  static const String USER_META = "usermeta";
  static const String USER_DATA = "userdata";
  static const String VOCAB_LISTS = "vocabLists";

  final LoggerService _log;
  Learner learner;
  firebase.User fbUser;

  firebase.Auth _fbAuth;
  firebase.GoogleAuthProvider _fbGoogleAuthProvider;
  firebase.Database _fbDatabase;
  // Language database reference
  firebase.DatabaseReference fbLangData;
  firebase.DatabaseReference fbLangMeta;
  // User database reference
  firebase.DatabaseReference fbLanguagesList;
  firebase.DatabaseReference fbUserData;
  firebase.DatabaseReference fbUserMeta;
  firebase.DatabaseReference fbVocabLists;

  //Languages info
  Map languagesData = {};
  Map languagesMeta = {};
  List<String> languageList = [];
  String currentLanguage = "";

  // User info
  Map<String, dynamic> userData = {};
//  Map userMeta = {};
  Map<String, Map<String, String>> vocabLists = {};

  FirebaseService(LoggerService this._log) {
    _log.info("$runtimeType");
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
    fbLanguagesList = _fbDatabase.ref("languagesList");
    fbLangMeta = _fbDatabase.ref("languagesMeta");
    fbLangData = _fbDatabase.ref("languagesData");
  }

  Future getLanguagesData() async {
    _log.info("$runtimeType::getLanguagesData()");
    if (languagesData.isEmpty) {
//      fbLangData = _fbDatabase.ref("languagesData");
      fbLangData.onValue.listen((firebase.QueryEvent e) async {
        languagesData = await e.snapshot.val();
      });
    }
    return languagesData;
  }

  Future getLanguagesMeta() async {
    _log.info("$runtimeType::getLanguagesMeta()");
    if (languagesMeta.isEmpty) {
//      fbLangMeta = _fbDatabase.ref("languagesMeta");
      fbLangMeta.onValue.listen((firebase.QueryEvent e) async {
        languagesMeta = await e.snapshot.val();
      });
    }
    return languagesMeta;
  }

  Future<List<String>> getLanguageList() async {
    if (languageList == null || languageList.isEmpty) {
      _log.info("$runtimeType::getLanguageList()");
//      fbLanguagesList = _fbDatabase.ref("languagesList");
      fbLanguagesList.onValue.listen((firebase.QueryEvent e) async {
        languageList = await e.snapshot.val();
        _log.info("$runtimeType::getLanguageList()-- languageList snapshot = ${e.snapshot.val()}");
        _log.info("$runtimeType::getLanguageList()-- languageList = ${languageList}");
        _log.info("$runtimeType::getLanguageList()-- languageList snapshot.runtimeType = ${e.snapshot.val().runtimeType}");
      });
    }
    return languageList;
  }

//  List<String> getLangList() {
//    List ll;
//    getLanguageList().then((llist){
//      ll = llist;
//      return llist;
//    });
//    return ll;
//  }


  Future<Map> getUserData(String userID) async {
    _log.info("$runtimeType::getUserData($userID)");
    if (userData == null || userData.isEmpty) {
      _log.info("$runtimeType::getUserData($userID) == null!");
      fbUserData = _fbDatabase.ref("$USER_DATA/$userID");
      fbUserData.onValue.listen((firebase.QueryEvent e) async {
        userData = await e.snapshot.val();
        learner = new Learner.fromMap(_log, userData);
        _log.info("$runtimeType::getUserData()::userData.runtimeType = ${userData?.runtimeType}");
        _log.info("$runtimeType::getUserData()::userData snapshot = $userData");
        _log.info("$runtimeType::getUserData()::learner = ${learner}");
        if (userData.containsKey('currentLanguage') && userData['currentLanguage'].isNotEmpty) {
          _log.info("$runtimeType::getUserData()::userData.containsKey('currentLanguage') == ${userData.containsKey('currentLanguage')}");
          currentLanguage = userData['currentLanguage'];
        }
        else {
          _log.info("$runtimeType::getUserData()::languageList = $languageList");
          currentLanguage = languageList[0];
        }
        _log.info("$runtimeType::getUserData()::userData = $userData");
      });
      return userData; // This seems entirely unnecessary.
    }
    return userData;
  }

//  Future getUserMeta(String userID) async {
//    _log.info("$runtimeType::getUserMeta($userID)");
//    if (userMeta == null || userMeta.isEmpty) {
//      fbUserMeta = _fbDatabase.ref("$USER_META/$userID");
//      fbUserMeta.onChildAdded.listen((firebase.QueryEvent e) async {
//        userMeta = await e.snapshot.val();
//        _log.info("$runtimeType::getUserMeta()::userMeta = $userMeta");
//      });
//    }
//    return userMeta;
//  }

  Future getVocabLists(String userID) async {
    _log.info("$runtimeType::getVocabLists($VOCAB_LISTS/$userID)");
    if (vocabLists == null || vocabLists.isEmpty) {
      fbVocabLists = _fbDatabase.ref("$VOCAB_LISTS/$userID");
      fbVocabLists.onValue.listen((firebase.QueryEvent e) async {
        vocabLists = await e.snapshot.val();
        _log.info("$runtimeType::getVocabLists()::vocabLists = $vocabLists");
      });
    }
    return vocabLists;
  }

  String getCurrentLanguage() {
    _log.info("$runtimeType::getCurrentLanguage()");
    if (learner?.currentLanguage == null || learner.currentLanguage.isEmpty) {
      if (languageList == null || languageList.isEmpty) {
        return "";
      }
      else {
//        return languageList[0];
      return "boners";
      }
    }
    else {
      currentLanguage = learner.currentLanguage;
      return learner.currentLanguage;
    }
  }

  _authChanged(firebase.User newUser) async {
    if (newUser == null) {
      _log.info("$runtimeType::_authChanged(null)");
    }
    if (newUser != null) {
      _log.info("$runtimeType::_authChanged($newUser)");
      fbUser = newUser;
//      await getUserMeta(newUser.uid);
      getUserData(newUser.uid).then((newLearner) {
        learner = new Learner.fromMap(_log, newLearner);
        _log.info("$runtimeType::_authChanged()::newLearner = $newLearner");
        _log.info("$runtimeType::_authChanged()::learner = $learner");
        currentLanguage = getCurrentLanguage();
        getVocabLists(newUser.uid).then((vlists) {
          _log.info("$runtimeType::_authChanged()::vocabLists = $vlists");
          learner.vocabLists = vlists;
        });
      });

//      learner = new Learner.fromMap(_log, userData);
//      learner.vocabLists = vocabLists;
    }
  }

  Future signIn() async {
    try {
      await _fbAuth.signInWithPopup(_fbGoogleAuthProvider);
      _log.info("$runtimeType::signIn() --signing in...");
    }
    catch (error) {
      _log.info("$runtimeType::signIn() -- $error");
    }
  }

  void signOut() {
    _log.info("$runtimeType::signOut()");
    _fbAuth.signOut();
  }


  Future<Null> addWord(String newWord, [String def = ""]) async {
    learner.vocabLists[currentLanguage][newWord] = def;
    await fbVocabLists.update(learner.vocabLists);
  }

  Future<Null> removeWord(String oldWord) async {
    learner.vocabLists[currentLanguage].remove(oldWord);
    await fbVocabLists.update(learner.vocabLists);
  }
} // end class FirebaseService