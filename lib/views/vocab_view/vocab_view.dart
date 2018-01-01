import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/models/word.dart';
import 'package:dart_toast/dart_toast.dart';

@Component(
  selector: 'vocab-view',
  styleUrls: const ['vocab_view.css'],
  templateUrl: 'vocab_view.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders]
)
class VocabView implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;

  List<String> views = const [
    "Add Words",
    "List View",
    "Flashcards"
  ];
  String currentView = "";

//  Map<String, Map<String, String>> allVocabLists = {};
//  Map<String, String> vocabList = {};
  VocabularyList masterVocabList;
  List<Word> vocabList;
//  List<String> wordList = [];
//  List<String> defList = [];
  bool editMode = false;
  bool menuVisible = false;
  bool defVisible = true;
  bool listOrderWordFirst = true;

  /* Flashcards */
  bool cardOrderWordFirst = true;
  bool showingWord = true;
  int cardIndex = 0;

//  SplayTreeMap<String, String> sortedVocab;
  String newWord = "";
  String newDef = "";
//  bool setNoun = false;
//  bool setPronoun = false;
//  bool setAdj = false;
//  bool setVerb = false;
//  bool setAdverb = false;
//  bool setPrep = false;
//  bool setConjunc = false;
//  bool setInterject = false;
  String cat = "";
  String subcat = "";
//  bool isMem = false;
//  bool tempMem = false;

  Map<String, bool> wordOptions = {
    "setNoun": false,
    "setPronoun": false,
    "setAdj": false,
    "setVerb": false,
    "setAdverb": false,
    "setPrep": false,
    "setConjunc": false,
    "setInterject": false,
    "isMem": false,
    "tempMem": false,
    "multiple": false
  };

  VocabView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
    if (vocabList == null || vocabList.isEmpty) {
      currentView = views[1];
    }
    else {
      currentView = views[0];
    }
  }

  void changeOptionStatus(String opt) {
    _log.info("$runtimeType::changeOptionStatus($opt) -- setting $opt to ${!wordOptions[opt]}");
    wordOptions[opt] = ! wordOptions[opt]; // Change its truthiness?
  }

  @override
  ngOnInit() async {
    _log.info("$runtimeType::ngonInit()");
    await fbService.getVocabLists(fbService.fbUser.uid).then((VocabularyList allLists) async {
      masterVocabList = allLists;
      vocabList = masterVocabList[fbService.currentLanguage];
      if (vocabList == null || vocabList.isEmpty) {
        currentView = views[1];
      }
      else {
        currentView = views[0];
      }
    });
  }

  void changeEditMode() {
    _log.info("$runtimeType()::changeEditMode()");
    editMode = (!editMode);
    new Toast("Toast!", "The toastiest toast", position: ToastPos.bottomCenter);
  }

  void changeListView() {
    _log.info("$runtimeType()::changeListView()");
    defVisible = (!defVisible);
  }

  void changeListWordView() {
    _log.info("$runtimeType()::changeListWordView()");
    listOrderWordFirst = (!listOrderWordFirst);
  }

  void changeCardView() {
    _log.info("$runtimeType()::changeCardView()");
    cardOrderWordFirst = (!cardOrderWordFirst);
  }

  void cardClick() {
    _log.info("$runtimeType()::cardClick()");
    showingWord = (!showingWord);
  }

  void previousCard() {
    _log.info("$runtimeType()::previousCard()");
    if (cardIndex > 0) { // Already on first card.
      showingWord = true;
      cardIndex--;
    }
  }
  void nextCard() {
    _log.info("$runtimeType()::nextCard()");
//    if (cardIndex < (vocabList.length - 1)) { // Already on first card.
    if (cardIndex < (masterVocabList.listLengthForLang(fbService.currentLanguage) - 1)) { // Already on first card.
      showingWord = true;
      cardIndex++;
    }
  }

  void toggleMenu() {
    _log.info("$runtimeType()::toggleMenu())");
    menuVisible = (!menuVisible);
  }

  void changeVocabView(int newIndex) {
    _log.info("$runtimeType()::changeVocabView($newIndex)");
//    currentView = views[newIndex];
    currentView = views.elementAt(newIndex);
  }

  ///todo: THIS (and in html)
//  void addFull(String newName, [String newDef = "", bool setNoun = false, bool setPronoun = false, bool setAdj = false, bool setVerb = false, bool setAdverb = false, bool setPrep = false, bool setConjunc = false, bool setInterject = false, String cat = "", String subcat = "", bool isMem = false, bool tempMem = false]) {
  void addFull(String newName, [String newDef = "", Map<String, bool> wOptions, String cat = "", String subcat = ""]) {
    _log.info("$runtimeType::addFull() adding word: ${fbService.currentLanguage}, $newName, $newDef, noun: ${wOptions["setNoun"]}, pronoun: ${wOptions["setPronoun"]},adjective: ${wOptions["setAdj"]}, verb: ${wOptions["setVerb"]}, adverb: ${wOptions["setAdverb"]}, preposition: ${wOptions["setPrep"]}, conjunction: ${wOptions["setConjunc"]}, interjection: ${wOptions["setInterject"]}, $cat, $subcat)");
//    Word newWord = new Word(fbService.currentLanguage, newName, newDef, setNoun, setPronoun, setAdj,setVerb, setAdverb, setPrep, setConjunc, setInterject, cat, subcat, false, false);
    Map wMap = wOptions;
//    wMap = wOptions;
    wMap["language"] = fbService.currentLanguage;
    wMap["wordName"] = newName;
    wMap["definition"] = newDef;
    wMap["category"] = cat;
    wMap["subcategory"] = subcat;
    Word newWord = new Word.fromMap(wMap);
    masterVocabList.addWord(newWord);
//    vocabList.add(newWord);
    fbService.addWord(newWord);
  }

  void addQuick(String word, [String definition = ""]) {
    _log.info("$runtimeType()::add($word, $definition)");
    // I think this does the above two functions in one line.
//    wordList.add(word.toLowerCase());
//    defList.add(definition.toLowerCase());
//    vocabList[word.toLowerCase()] = definition.toLowerCase();
//    Word nw = new Word.quickAdd(fbService.currentLanguage, word, definition);
    masterVocabList.addWord(new Word.quickAdd(fbService.currentLanguage, word, definition));
//    vocabList.add(new Word.quickAdd(fbService.currentLanguage, word, definition));
    fbService.addWordQuick(word.toLowerCase(), definition.toLowerCase());
    //newSetWords.add(description);
  }
//  String remove(int index) => newListWords.removeAt(index);
  void remove(Word oldWord) {
    _log.info("$runtimeType()::remove(${oldWord.wordName})");
//    int idx = wordList.indexOf(word);
//    wordList.removeWhere((String wrd) => wrd == word.wordName);
//    defList.removeWhere((String df) => df == word.definition);
//    wordList.removeAt(idx);
//    defList.removeAt(idx);
//    vocabList.remove(word);
    masterVocabList.removeWord(oldWord);
    vocabList.remove(oldWord);
    fbService.removeWord(oldWord);
//    fbService.learner.vocabLists.removeWord(oldWord);

//    fbService.removeWord(word);
  }
}