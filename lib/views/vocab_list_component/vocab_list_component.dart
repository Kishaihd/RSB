
//import 'dart:async';
//import 'dart:collection'; // In case I use a SplayTreeMap
//import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:RSB/services/firebase_service.dart';
import 'package:RSB/services/logger_service.dart';

@Component(
  selector: 'vocab-list',
  styleUrls: const ['vocab_list_component.css'],
  templateUrl: 'vocab_list_component.html',
  directives: const [CORE_DIRECTIVES, materialDirectives],
  providers: const [materialProviders],
)
class VocabListComponent implements OnInit {
  final LoggerService _log;
  final FirebaseService fbService;

  List<String> views = const [
      "add words",
      "list view",
      "flashcards"
  ];

  String currentView = "";


// There's gotta be a better way to do this.
  Map<String, Map<String, String>> allVocabLists;

  Map<String, String> vocabList = {};
//  @Input()
//  void set vocabList(Map vList) {
//    _vocabList = vList;
//  }
//  Map<String, String> get vocabList => _vocabList;


  ngOnInit() async {
//    allVocabLists = await fbService?.learner?.vocabLists;
    allVocabLists = await fbService.getVocabLists(fbService.fbUser.uid).then((allLists) async {
      vocabList = allLists[await fbService.getSelectedLanguage()];
    });
    _log.info("$runtimeType()::allVocabLists = ${fbService.learner.vocabLists}");
//    if (allVocabLists.containsKey(fbService.selectedLanguage) == false) {
//      allVocabLists[fbService.selectedLanguage] = {};
//    }

    if (vocabList != null && vocabList.isNotEmpty) {
      vocabList.forEach((String word, String def) {
        wordList.add(word);
        defList.add(def);
      });
    }
  }


//  _vocabList = fbService.learner.currentVocabList;
//  @Input()
//  void set vocabList(Map vl) {
//    _log.info("$runtimeType()::@Input(vocabList) ==> ${vl}");
//    if (_vocabList != vl) {
//      _vocabList = vl;
//      if (_vocabList != null && _vocabList.isNotEmpty) {
//        _vocabList.forEach((String word, String def) {
//          wordList.add(word);
//          defList.add(def);
//        });
//      }
//      else {
//        // Do nothing. Remove this else?
//      }
//      _initMe();
//    }
//  }


//  void _initMe() {
//    if (_vocabList == null) {
//      return;
//    }
//    _log.info("$runtimeType()::vocabList: ${_vocabList.toString()}");
//  }

//  Map<String, Map<String, String>> tempVocabMap = {};
  List<String> wordList = [];
  List<String> defList = [];

  bool editMode = false;
  bool menuVisible = false;
  bool defVisible = true;
  bool listOrderWordFirst = true;

  /* Flashcards */
  bool cardOrderWordFirst = true;
  bool showingWord = true;
  int cardIndex = 0;

//  List<String> newListWords = [];
//  Set<String> newSetWords = new Set(); // It's a vocab list, so each entry should be unique.

//  SplayTreeMap<String, String> sortedVocab;
  String newWord = "";
  String newDef = "";

  VocabListComponent(LoggerService this._log, this.fbService) {
    _log.info("$runtimeType");
//    allVocabLists = fbService.learner.vocabLists;
//    _log.info("$runtimeType()::allVocabLists = ${fbService.learner.vocabLists}");
//    if (allVocabLists.containsKey(fbService.selectedLanguage) == false) {
//      allVocabLists[fbService.selectedLanguage] = {};
//    }
//    _vocabList = allVocabLists[fbService.selectedLanguage];
//    if (_vocabList != null && _vocabList.isNotEmpty) {
//      _vocabList.forEach((String word, String def) {
//        wordList.add(word);
//        defList.add(def);
//      });
//    }
    currentView = views[0];
  }

  void changeEditMode() {
    _log.info("$runtimeType()::changeEditMode()");
    editMode = !editMode;
  }

  void changeListView() {
    _log.info("$runtimeType()::changeListView()");
    defVisible = !defVisible;
  }

  void changeListWordView() {
    _log.info("$runtimeType()::changeListWordView()");
    listOrderWordFirst = !listOrderWordFirst;
  }

  void changeCardView() {
    _log.info("$runtimeType()::changeCardView()");
    cardOrderWordFirst = !cardOrderWordFirst;
  }

  void cardClick() {
    _log.info("$runtimeType()::cardClick()");
    showingWord = !showingWord;
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
    if (cardIndex < (vocabList.length - 1)) { // Already on first card.
      showingWord = true;
      cardIndex++;
    }
  }

  void toggleMenu() {
    _log.info("$runtimeType()::toggleMenu())");
    menuVisible = !menuVisible;
  }

  void changeVocabView(int newIndex) {
    _log.info("$runtimeType()::changeVocabView($newIndex)");
//    currentView = views[newIndex];
    currentView = views.elementAt(newIndex);
  }

  void add(String word, [String definition = ""]) {
    _log.info("$runtimeType()::add($word, $definition)");
  // I think this does the above two functions in one line.
    wordList.add(word);
    defList.add(definition);
    vocabList[word] = definition;
    fbService.addWord(word, definition);
    //newSetWords.add(description);
  }
//  String remove(int index) => newListWords.removeAt(index);
  void remove(String word) {
    _log.info("$runtimeType()::remove($word)");
    int idx = wordList.indexOf(word);
    wordList.removeAt(idx);
    defList.removeAt(idx);
    vocabList.remove(word);
  }
//  void onReorder(ReorderEvent e) => vocabMap.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
//      newListWords.insert(e.destIndex, newListWords.removeAt(e.sourceIndex));
}
