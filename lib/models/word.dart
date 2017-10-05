import 'package:RSB/services/logger_service.dart';

class Word {
//  final LoggerService _log;
  static String capitalizeMe(String oldstr) {
    if (oldstr == null || oldstr.isEmpty) {
      return "";
    }

    String newString = oldstr;

    newString[0].toUpperCase();
    return newString;
  }

  String language;

  String wordName;
  String definition;

  String category;
  String subcategory;

  // Part of speech
  bool isNoun = false;
  bool isPronoun = false;
  bool isAdjective = false;
  bool isVerb = false;
  bool isAdverb = false;
  bool isPreposition = false;
  bool isConjunction = false;
  bool isInterjection = false;
//  bool isGerund = false;

  bool isMemorized;
  bool tempMemorizedFlag;

  Word(String fromLang, String newName, [String newDef = "", bool setNoun = false, bool setPronoun = false, bool setAdj = false, bool setVerb = false, bool setAdverb = false, bool setPrep = false, bool setConjunc = false, bool setInterject = false, String cat = "", String subcat = "", bool isMem = false, bool tempMem = false]) {
    language = fromLang;
    wordName = newName;
    definition = newDef;
    isNoun = setNoun;
    isPronoun = setPronoun;
    isAdjective = setAdj;
    isVerb = setVerb;
    isAdverb = setAdverb;
    isPreposition = setPrep;
    isConjunction = setConjunc;
    isInterjection = setInterject;
    category = cat;
    subcategory = subcat;
    isMemorized = isMem;
    tempMemorizedFlag = tempMem;
  }

  Word.quickAdd(String fromLang, String newWord, [String newDef = ""]) : this (fromLang, newWord, newDef);

  Word.fromMap(Map map) : this(map["language"], map["wordName"], map["definition"], map["isNoun"], map["isPronoun"], map["isAdjective"], map["isVerb"], map["isAdverb"], map["isPreposition"], map["isConjunction"], map["isInterjection"], map["category"], map["subcategory"], map["isMemorized"], map["isTempMemorized"]);

  Word.RUN_ONLY_ONCE(String lang, String name, String def) : this(lang, name, def);
  // For == compare just wordName.
//  operator==() {
//
//  }

  @override
  String toString() => wordName;

  Map toMap() {
    return {
      "language": language,
      "wordName": wordName,
      "definition": definition,
      "isNoun": isNoun,
      "isPronoun": isPronoun,
      "isAdjective": isAdjective,
      "isVerb": isVerb,
      "isAdverb": isAdverb,
      "isPreposition": isPreposition,
      "isConjunction": isConjunction,
      "category": category,
      "subcategory": subcategory,
      "isMemorized": isMemorized,
      "isTempMemorized": tempMemorizedFlag
    };
  }

  void markAsMemorized() {
    isMemorized = true;
  }

  void markAsForgotten() {
    isMemorized = false;
  }


  /* Have a timer set up for each word, so it can be set to
    memorized permanently, 
    memorized for a day, 3 days, a week, or two weeks? 
  */
}

// Set up some server-side code that compiles lists of words present in multiple
//  languages. :D
class VocabularyList {
  final LoggerService _log;
  // Map<language, List<word class>>
  Map<String, List<Word>> masterList;

  //Map<category, List<subcategory>>
  Map<String, List<String>> categories;

  VocabularyList(this._log, Map<String, List<Word>> mList) {
    _log.info("$runtimeType");
    masterList = mList;
  }

  Map toMap() {
    _log.info("$runtimeType::toMap()");
    ///todo: finish this.
    Map<String, Map<int, Map<String, String>>> mm = {};
    masterList.forEach((String lang, List<Word> lw) {
      _log.info("$runtimeType::toMap() -- found $lang");
      mm[lang] = {};
      lw.forEach((Word w) {
        mm[lang][lw.indexOf(w)] = w.toMap();
        _log.info("$runtimeType::toMap() mm[$lang][${lw.indexOf(w)}] = ${w.toMap()}");
//        mm[lang].addAll(w.toMap());  //[w.wordName] = w.toMap();
      });
    });
    _log.info("$runtimeType::toMap():: returning $mm");
    return mm;
  }

  List<Word> getListForLang(String lang) {
    _log.info("$runtimeType::getListForLang($lang)");
    if (masterList.containsKey(lang)) {
      return masterList[lang];
    }
    else {
      return [];
    }
  }

  operator[](String lang) => masterList[lang];
  operator[]=(String lang, Word newWord) => masterList[lang].add(newWord);

  int listLengthForLang(String lang) => masterList[lang].length;

  void addWord(Word newWord) {
    _log.info("$runtimeType::addWord($newWord)");
    if (masterList.containsKey(newWord.language)) { // Language present in masterList.
      masterList[newWord.language].add(newWord);
    }
    else {
      masterList[newWord.language] = [];
      masterList[newWord.language].add(newWord);
    }
  }

  bool get isEmpty {
    return masterList.isEmpty;
  }

  bool get isNotEmpty {
    return masterList.isNotEmpty;
  }

  void removeWord(Word oldWord) {
    _log.info("$runtimeType::removeWord($oldWord)");
    if (masterList[oldWord.language].contains(oldWord)) {
      masterList[oldWord.language].remove(oldWord);
    }
    else {
      return;
    }
  }
}

///todo: Add categories and subcategories
/*
Animals
  Animals on the Farm
  Animals
  Fish
  Animals in a Zoo
  Birds
  Cat Breeds
  Deadliest Snakes in the World
  Dog Breeds
  Insects
  Pets
  Rattlesnakes
  Snakes
  Bugs
Body
  Human Teeth
  Hair Types
  Head
  Human Body
  Internal Organs
  Parts of the Hand
Body Care
  Cosmetics
  Makeup
  Manicure Instruments
  Shaving
Books and Things to Read
  Parts of a Book
  Types of Books
  Newspaper
Buildings
  Buildings in the City
  Castles
Business English
  Business English Nouns
  Business English Verbs
  Computer
  Jobs
  Job Application
Calendar
  Months
  Chinese Calendar
  Zodiac Signs
Cars
  Car Parts (British English)
  Car Parts (American English)
  Outside of a Car
  Under the Hood of a Car
  Cars Verbs
  Inside of a Car
Celebrations
  Party Names
City
  Downtown
  Post Office
  Bank
  City
Clothes
  Men's Clothes
  Sewing
  Shoes and Footwear
  Headgear and Hats
  Natural Materials Used in Clothes
  Underwear
Colors

Computers
  Computer
  Networking Computers
Countries
  Nationalities
Family
  Family Members
  Relatives
  Family Responsibilities (Chores)
Eating, Food & Drinks
  Catering
  Cuts of Beef
  Citrus Fruits
  Dinnerware
  Fruit
  Grains
  Kitchen Knifes
  Pasta Types
  Breads
  Condiments
  Desserts
  Drinks and Beverages
  Food
  Meat
  Restaurant (Short List)
  Salad Dressing
  Vegetables
  Diary Products
  Food Pyramid
  Supermarket Packaging
Gardening and Plants
  Bulb Vegetables
  Garden Tools
  Leaf Vegetables
  Root Vegetables
  Seed Vegetables
  Fruit Trees
  Trees
  Flowers
  Gardening Verbs
Geography
  Continents
  Geographic Features
Grammar & English Usage
  Adverbs of Cause
  Adverbs of Place
  Adverbs of Quantity
  Adverbs of Time
  Adverbs that Usually Come Before the Verb
  Compound Words
  Frequency Words and Phrases
  Prepositions
  Prepositions - A Longer List
  Punctuation Marks
Health
  Dental Care
  Injuries
  Aches and Pains
  People in Hospitals
Holidays
  Christmas - General
  Christmas - Religious
  Food at Christmas
  Halloween
  New Year's Day
  Saint Patrick's Day
  Thanksgiving
  Valentine's Day
  Holidays in the United States of America
House
  Building Material
  House
  Refrigerator
  Rooms and Places in a House
  Types of Houses and Places to Live
  Types of Roofs
  Woodburning Stoves
  Furniture in a House
  Things in a House
Jobs, Occupations and Professions
  Catering
  Job Application
  Jobs
  Fire Fighting
Law
  Crime Verbs
  Crime - Words Related to Crimes
  Crimes - Types of Crimes
  Criminals
  Justice System - Court
Math
  Shapes
  Math Angles
  Measuring Time
  Numbers 1-10
  Numbers 1-20
  Numbers 20-40
  Measurements
Miscellaneous
  Smoking
Money
  Paying Bills
  Money Used in the USA
Music
  Musical Instruments
  Brass Instruments
  Percussion Instruments
  Woodwind Instruments.
  Symphony Orchestra Instruments
Office
  Computer
  Stationery
  Telephone
Parts
  Bicycle Parts
  Gasoline Engine Parts
  Motorcycle Parts
  Parts of Books
People
  Adjectives for People
  Cowboys
  Criminals
  People in Education
  People in Hospitals
School
  Degrees in Education
  Education
  School Rooms
  School Subjects
  People in a School
  Types of Schools
  University Subjects
  Tests
Science
  Gases
  Liquids
  Metals
  Materials
Seasons
  Winter
Security
  Crimes
  Weapons
Sports
  Baseball
  Baseball (Short List)
  Baseball Pitches
  Baseball Positions
  Baseball Verbs
  Football Positions (American Football)
  Olympic Sports
  Sports Played with a Ball
  Sportswear
Swimming
  Swimming Strokes
Time
  Days of the Week
  Months
  Zodiac Signs
  Chinese Calendar
Tools
  Carpentry Tools
  Farm Machinery
  Ladders
  Plumbing Tools
  Woodworking Tools
Transportation
  Aircraft
  Land Transportation
  Types of Ships
  Vehicles
  Water Transportation
Travel
  Airport Departure and Arrival
  Harbor
  Hotel
  Luggage
  Also, see "Transportation" above.
Weather
  Weather (Short List)
Perhaps Not So Useful
  Imaginary People and Animals

*/