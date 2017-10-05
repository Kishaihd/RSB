import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/models/word.dart';

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

  @override
  ngOnInit() async {
    _log.info("$runtimeType::ngonInit()");
    // THIS ONLY RUNS ONE TIME TO FORMAT THE FIREBASE!
//    await fbService.getVocabLists(fbService.fbUser.uid).then((Map<String, Map<String, String>> allLists) async {
    await fbService.getVocabLists(fbService.fbUser.uid).then((VocabularyList allLists) async {
      masterVocabList = allLists;
      vocabList = masterVocabList[fbService.currentLanguage];
    });
//    _log.info("$runtimeType::ngOnInit()::learner.vocabLists = ${fbService.learner.vocabLists}");
  }

  VocabView(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
    currentView = views[0];
  }

  void changeEditMode() {
    _log.info("$runtimeType()::changeEditMode()");
    editMode = (!editMode);
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

  void addFull(String newName, [String newDef = "", bool setNoun = false, bool setPronoun = false, bool setAdj = false, bool setVerb = false, bool setAdverb = false, bool setPrep = false, bool setConjunc = false, bool setInterject = false, String cat = "", String subcat = "", bool isMem = false, bool tempMem = false]) {
    _log.info("$runtimeType::addFull() adding word: ${fbService.currentLanguage}, $newName, $newDef, $setNoun, $setPronoun, $setAdj,$setVerb, $setAdverb, $setPrep, $setConjunc, $setInterject, $cat, $subcat, false, false)");
    Word newWord = new Word(fbService.currentLanguage, newName, newDef, setNoun, setPronoun, setAdj,setVerb, setAdverb, setPrep, setConjunc, setInterject, cat, subcat, false, false);
    masterVocabList.addWord(newWord);
    vocabList.add(newWord);
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
    vocabList.add(new Word.quickAdd(fbService.currentLanguage, word, definition));
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