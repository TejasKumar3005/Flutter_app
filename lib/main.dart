import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "BuxtonSketch",
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => new _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  int points_earned = 0;
  List<int> levels=[750,2000,5000,10000];
  int level=0;
  SharedPreferences prefs;
  final FlutterTts flutterTts = FlutterTts();
  Future _speak(text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
    _speak("WHAT DO YOU WANT TO ATTEMPT");
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {


      points_earned = prefs.getInt("POINTS") ?? 0;

      if(points_earned<levels[0]){
        level=0;
      }
      else if(points_earned<levels[1]){
        level=1;
      }
      else if(points_earned<levels[2]){
        level=2;
      }
      else if(points_earned<levels[3]){
        level=3;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    getPrefs();
    return SafeArea(
      child: new Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.jpeg"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                    child: LinearPercentIndicator(
                      animation: true,
                      lineHeight: 25.0,
                      animationDuration: 9000,
                      percent: level>0?(points_earned-levels[level-1])/levels[level]:points_earned/levels[level],
                      center: Text((level>0?(points_earned-levels[level-1]):points_earned).toString()),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.lightGreen,
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          level>0?Text("Level "+(level).toString()+ "("+levels[level-1].toString()+")"):Container(),
                          Text("Level "+(level+1).toString() + "("+levels[level].toString()+")"),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedContainer(
                        child: Image.asset(
                          "assets/welcome.gif",
                          height: 150,
                          width: 100,
                        ),
                        duration: Duration(seconds: 1000),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "WHAT DO YOU WANT TO ATTEMPT",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'BuxtonSketch',
                              fontSize: 43,
                              color: Color.fromRGBO(133, 51, 255, 1),
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: FloatingActionButton.extended(
                                      heroTag: "RandomBtn",
                                      label: Text("RANDOMLY"),
                                      backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                      onPressed: () {
                                        Navigator.of(context).push(new RandomPageRoute()).then((value) => getPrefs());
                                      }),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: FloatingActionButton.extended(
                                      heroTag: "AlphabeticBtn",
                                      label: Text("ALPHABETIC"),
                                      backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(new AlphabeticPageRoute()).then((value) => getPrefs());
                                      }),
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: FloatingActionButton.extended(
                                      heroTag: "TwomBtn",
                                      label: Text("2 LETTER WORDS"),
                                      backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                      onPressed: () {
                                        Navigator.of(context).push(new TwoPageRoute()).then((value) => getPrefs());;
                                      }),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: FloatingActionButton.extended(
                                      heroTag: "threeBtn",
                                      label: Text("3 LETTER WORDS"),
                                      backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                      onPressed: () {
                                        Navigator.of(context).push(new ThreePageRoute()).then((value) => getPrefs());;
                                      }),
                                ),
                              ])
                        ],
                      ),
                    ],
                  ),
                ]),
          )),
    );
  }
}

class RandomPageRoute extends CupertinoPageRoute {
  RandomPageRoute()
      : super(builder: (BuildContext context) => new RandomPage());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new RandomPage());
  }
}

class RandomPage extends StatefulWidget {
  @override
  _RandomPageState createState() => new _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  Random random;
  String _text = '';

  // ignore: non_constant_identifier_names

  int number = 7;
  int points = 0;
  static int points_earned = 0;
  SharedPreferences prefs;

  static Map<int, int> points_arr = {
    1: 20,
    2: 20,
    3: 20,
    4: 20,
    5: 20,
    6: 25,
    7: 25,
    8: 25,
    9: 20,
    10: 25,
    11: 20,
    12: 20,
    13: 25,
    14: 20,
    15: 20,
    16: 20,
    17: 25,
    18: 25,
    19: 20,
    20: 15,
    21: 15,
    22: 15,
    23: 25,
    24: 25,
    25: 20,
    26: 20
  };
  Map<int, String> alphabets = {
    1: "A",
    2: "B",
    3: "D",
    4: "D",
    5: "K",
    6: "F",
    7: "G",
    8: "H",
    9: "I",
    10: "J",
    11: "K",
    12: "L",
    13: "M",
    14: "N",
    15: "O",
    16: "P",
    17: "Q",
    18: "R",
    19: "S",
    20: "T",
    21: "U",
    22: "V",
    23: "W",
    24: "X",
    25: "Y",
    26: "Z"
  };

  Map<String, List> pronun = {
    "A": ["A", "a", "ywrfgugf"],
    "B": ["B", "b", "efwefewf"],
    "C": ["C", "c", "fewfwefw"],
    "D": ["D", "d", "fewfwf"],
    "E": ["E", "e", "efwfeds"],
    "F": ["F", "f", "app"],
    "G": ["G", "ji", "g"],
    "H": ["H", "h", "egg"],
    "I": ["I", "i", "grgthg"],
    "J": ["J", "Jay", "j"],
    "K": ["K", "ke", "k"],
    "L": ["L", "l", "erfetrge"],
    "M": ["M", "m", "rgtryh"],
    "N": ["N", "n", "yhujju"],
    "O": ["O", "o", "trhrthy"],
    "P": ["P", "p", "thyju"],
    "Q": ["Q", "q", "kyon"],
    "R": ["R", "r", "are"],
    "S": ["S", "s", "thyrth"],
    "T": ["T", "t", "trhryh"],
    "U": ["new", "you", "u"],
    "V": ["V", "v", "rtyhrh"],
    "W": ["W", "w", "thrhfg"],
    "X": ["x", "eggs", "egg"],
    "Y": ["why", "tut", "y"],
    "Z": ["Z", "z", "v"],
  };

  bool correct = false;
  bool wrong = false;
  List<int> levels=[750,2000,5000,10000];
  int level=0;
  final FlutterTts flutterTts = FlutterTts();
  Future _speak(text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(.85);
    await flutterTts.setPitch(.85);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
    _speak("try speaking g");
    _speech = stt.SpeechToText();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {


      points_earned = prefs.getInt("POINTS") ?? 0;
      
      if(points_earned<levels[0]){
        level=0;
      }
      else if(points_earned<levels[1]){
        level=1;
      }
      else if(points_earned<levels[2]){
        level=2;
      }
      else if(points_earned<levels[3]){
        level=3;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    String alphabet = alphabets[number];
    return SafeArea(
      child: Scaffold(
          body: Stack(children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    child: Image.asset("assets/try.gif"),
                    duration: Duration(seconds: 1000),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        ' try speaking : $alphabet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'BuxtonSketch',
                          fontSize: 45,
                          color: Color.fromRGBO(133, 51, 255, 1),
                        ),
                      ),
                      AvatarGlow(
                        animate: _isListening,
                        glowColor: Color.fromRGBO(133, 51, 255, 1),
                        endRadius: 75.0,
                        duration: const Duration(milliseconds: 2000),
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        repeat: true,
                        child: FloatingActionButton(
                          heroTag: "RandomListen",
                          backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                          onPressed: () => _listen(alphabet),
                          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                width: correct ? double.infinity : 0,
                height: correct ? double.infinity : 0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bg.jpeg"),
                    fit: BoxFit.fill,
                  ),
                ),
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                        child: LinearPercentIndicator(
                          animation: true,
                          lineHeight: 25.0,
                          animationDuration: 9000,
                          percent: level>0?(points_earned-levels[level-1])/levels[level]:points_earned/levels[level],
                          center: Text((level>0?(points_earned-levels[level-1]):points_earned).toString()),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.lightGreen,
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              level>0?Text("Level "+(level).toString()+ "("+levels[level-1].toString()+")"):Container(),
                              Text("Level "+(level+1).toString() + "("+levels[level].toString()+")"),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/cake.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/correct.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/star.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "CORRECT WELL DONE",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'BuxtonSketch',
                                  fontSize: 23,
                                  color: Color.fromRGBO(0, 255, 0, 1),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    FloatingActionButton.extended(
                                        heroTag: "BackBtn",
                                        label: Text(
                                          "BACK",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'BuxtonSketch',
                                            fontSize: 25,
                                          ),
                                        ),
                                        backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                        onPressed: () {
                                          setState(() => correct = false);
                                          _speak("Try Speaking $alphabet");
                                        }),
                                    FloatingActionButton.extended(
                                        heroTag: "NextBtn",
                                        label: Text(
                                          "NEXT",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'BuxtonSketch',
                                            fontSize: 25,
                                          ),
                                        ),
                                        backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                        onPressed: () {
                                          setState(
                                                  () => number = new Random().nextInt(26) + 1);
                                          setState(() => alphabet = alphabets[number]);

                                          setState(() => correct = false);
                                          _speak("Try Speaking $alphabet");
                                        }),
                                  ])
                            ],
                          ),
                        ],
                      ),
                    ]
                )
            ),

            Container(
              width: wrong ? double.infinity : 0,
              height: wrong ? double.infinity : 0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    child: Image.asset(
                      "assets/sorry.gif",
                      height: 250,
                      width: 200,
                    ),
                    duration: Duration(seconds: 1000),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "OHH PLEASE TRY AGAIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'BuxtonSketch',
                          fontSize: 43,
                          color: Color.fromRGBO(0, 255, 0, 1),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton.extended(
                                heroTag: "TryBtn",
                                label: Text(
                                  "TRY AGAIN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'BuxtonSketch',
                                    fontSize: 25,
                                  ),
                                ),
                                backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                onPressed: () {
                                  setState(() => wrong = false);
                                  _speak("Try Speaking $alphabet");
                                }),
                            FloatingActionButton.extended(
                                heroTag: "WrongNextBtn",
                                label: Text(
                                  " NEXT",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'BuxtonSketch',
                                    fontSize: 25,
                                  ),
                                ),
                                backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                onPressed: () {
                                  setState(() => wrong = false);

                                  setState(
                                          () => number = new Random().nextInt(26) + 1);
                                  setState(() => alphabet = alphabets[number]);

                                  _speak("Try Speaking $alphabet");
                                }),
                          ])
                    ],
                  ),
                ],
              ),
            ),
          ])),
    );
  }

  void _listen(String alphabet) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);

        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(
                "you have to speak ${pronun[alphabet][0]}, ${pronun[alphabet][1]}, ${pronun[alphabet][2]}");
            print(number);

            if (!(_text == "")) {
              if (alphabet == "C" || alphabet == "E") {
                setState(() => number = number + 1);

                setState(() => _text = "");
                if(_isListening){
                  setState(() => points_earned += points_arr[number]);
                  callPointsEarned();
                  print("Points earned" +
                      points_earned.toString() +
                      " - " +
                      points_arr[number].toString());
                }
                setState(() => _isListening = false);
                setState(() => alphabet = alphabets[number]);


                _speak("Correct well done. try speaking $alphabet");

                _speech.stop();

                print("Points earned" +
                    points_earned.toString() +
                    " - " +
                    points_arr[number].toString());
              }
            }

            if (!(_text == "")) {
              if (_text == pronun[alphabet][0] ||
                  _text == pronun[alphabet][1] ||
                  _text == pronun[alphabet][2]) {
                print("correct");
                print("you spoke $_text");
                setState(() => correct = true);
                setState(() => _text = "");

                _speak("Correct well done");
                if(_isListening){
                  setState(() => points_earned += points_arr[number]);
                  callPointsEarned();
                  print("Points earned" +
                      points_earned.toString() +
                      " - " +
                      points_arr[number].toString());
                }
                setState(() => _isListening = false);


              } else {
                print("wrong");
                print("you spoke $_text");
                setState(() => wrong = true);
                setState(() => number = number);
                setState(() => _text = "");
                _speak("oh please try again");
                setState(() => _isListening = false);
              }
            }

            if (_speech.isNotListening) {
              setState(() => _isListening = false);
              setState(() => _text = "");

              _speech.stop();
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void callPointsEarned() {
    prefs.setInt("POINTS", points_earned);
    
  }

}

class AlphabeticPageRoute extends CupertinoPageRoute {
  AlphabeticPageRoute()
      : super(builder: (BuildContext context) => new AlphabeticPage());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new AlphabeticPage());
  }
}

class AlphabeticPage extends StatefulWidget {
  @override
  _AlphabeticPageState createState() => new _AlphabeticPageState();
}

class _AlphabeticPageState extends State<AlphabeticPage> {
  stt.SpeechToText _speech;
  bool _isListening = false;

  String _text = '';

  // ignore: non_constant_identifier_names

  int number = 1;
  int points = 0;
  int points_earned = 0;
  Map<int, int> points_arr = {
    1: 20,
    2: 20,
    3: 15,
    4: 20,
    5: 20,
    6: 25,
    7: 25,
    8: 25,
    9: 20,
    10: 25,
    11: 20,
    12: 20,
    13: 25,
    14: 20,
    15: 20,
    16: 20,
    17: 25,
    18: 25,
    19: 20,
    20: 15,
    21: 15,
    22: 15,
    23: 25,
    24: 25,
    25: 20,
    26: 20
  };
  Map<int, String> alphabets = {
    1: "A",
    2: "B",
    3: "C",
    4: "D",
    5: "E",
    6: "F",
    7: "G",
    8: "H",
    9: "I",
    10: "J",
    11: "K",
    12: "L",
    13: "M",
    14: "N",
    15: "O",
    16: "P",
    17: "Q",
    18: "R",
    19: "S",
    20: "T",
    21: "U",
    22: "V",
    23: "W",
    24: "X",
    25: "Y",
    26: "Z"
  };

  Map<String, List> pronun = {
    "A": ["A", "a", "ywrfgugf"],
    "B": ["B", "b", "efwefewf"],
    "C": ["C", "c", "fewfwefw"],
    "D": ["D", "d", "fewfwf"],
    "E": ["E", "e", "efwfeds"],
    "F": ["F", "f", "app"],
    "G": ["G", "ji", "g"],
    "H": ["H", "h", "egg"],
    "I": ["I", "i", "grgthg"],
    "J": ["J", "Jay", "j"],
    "K": ["K", "ke", "k"],
    "L": ["L", "l", "erfetrge"],
    "M": ["M", "m", "rgtryh"],
    "N": ["N", "n", "yhujju"],
    "O": ["O", "o", "trhrthy"],
    "P": ["P", "p", "thyju"],
    "Q": ["Q", "q", "kyon"],
    "R": ["R", "r", "are"],
    "S": ["S", "s", "thyrth"],
    "T": ["T", "t", "trhryh"],
    "U": ["new", "you", "u"],
    "V": ["V", "v", "rtyhrh"],
    "W": ["W", "w", "thrhfg"],
    "X": ["x", "eggs", "egg"],
    "Y": ["why", "tut", "y"],
    "Z": ["Z", "z", "rthrthr"],
  };
  int level=0;
  List<int> levels=[750,2000,5000,10000];

  bool correct = false;
  bool wrong = false;
  bool finish = false;
  SharedPreferences prefs;
  final FlutterTts flutterTts = FlutterTts();
  Future _speak(text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(.85);
    await flutterTts.setPitch(.85);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    _speak("try speaking ae");
    _speech = stt.SpeechToText();
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {


      points_earned = prefs.getInt("POINTS") ?? 0;
      if(points_earned<levels[0]){
        level=0;
      }
      else if(points_earned<levels[1]){
        level=1;
      }
      else if(points_earned<levels[2]){
        level=2;
      }
      else if(points_earned<levels[3]){
        level=3;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    String alphabet = alphabets[number];
    return SafeArea(
      child: Scaffold(
          body: Stack(children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    child: Image.asset("assets/try.gif"),
                    duration: Duration(seconds: 1000),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        ' try speaking : $alphabet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'BuxtonSketch',
                          fontSize: 45,
                          color: Color.fromRGBO(133, 51, 255, 1),
                        ),
                      ),
                      AvatarGlow(
                        animate: _isListening,
                        glowColor: Color.fromRGBO(133, 51, 255, 1),
                        endRadius: 75.0,
                        duration: const Duration(milliseconds: 2000),
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        repeat: true,
                        child: FloatingActionButton(
                          heroTag: "RandomListen",
                          backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                          onPressed: () => _listen(alphabet),
                          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                width: correct ? double.infinity : 0,
                height: correct ? double.infinity : 0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bg.jpeg"),
                    fit: BoxFit.fill,
                  ),
                ),
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                        child: LinearPercentIndicator(
                          animation: true,
                          lineHeight: 25.0,
                          animationDuration: 9000,
                          percent: level>0?(points_earned-levels[level-1])/levels[level]:points_earned/levels[level],
                          center: Text((level>0?(points_earned-levels[level-1]):points_earned).toString()),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.lightGreen,
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              level>0?Text("Level "+(level).toString()+ "("+levels[level-1].toString()+")"):Container(),
                              Text("Level "+(level+1).toString() + "("+levels[level].toString()+")"),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/cake.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/correct.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/star.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "CORRECT WELL DONE",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'BuxtonSketch',
                                  fontSize: 23,
                                  color: Color.fromRGBO(0, 255, 0, 1),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    FloatingActionButton.extended(
                                    heroTag: "BackBtn",
                                    label: Text(
                                      "TRY AGAIN",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'BuxtonSketch',
                                        fontSize: 25,
                                      ),
                                    ),
                                    backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                    onPressed: () {
                                      setState(() => correct = false);
                                      _speak("Try Speaking $alphabet");
                                    }),
                                FloatingActionButton.extended(
                                    heroTag: "NextBtn",
                                    label: Text(
                                      " NEXT",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'BuxtonSketch',
                                        fontSize: 25,
                                      ),
                                    ),
                                    backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                    onPressed: () {
                                      if (number < 27) {
                                        setState(() => number = number + 1);
                                        setState(() => alphabet = alphabets[number]);
                                        setState(
                                                () => points_earned += points_arr[number]);
                                        callPointsEarned();
                                        print("Points earned" +
                                            points_earned.toString() +
                                            " - " +
                                            points_arr[number].toString());

                                        setState(() => correct = false);
                                        _speak("Try Speaking $alphabet");
                                      } // if
                                      else {
                                        setState(() => correct = false);
                                        setState(() => finish = true);
                                      }
                                    } // onpressed
                                ),
                                  ])
                            ],
                          ),
                        ],
                      ),
                    ]
                )
            ),

            Container(
              width: wrong ? double.infinity : 0,
              height: wrong ? double.infinity : 0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    child: Image.asset(
                      "assets/sorry.gif",
                      height: 250,
                      width: 200,
                    ),
                    duration: Duration(seconds: 1000),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "OHH PLEASE TRY AGAIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'BuxtonSketch',
                          fontSize: 43,
                          color: Color.fromRGBO(0, 255, 0, 1),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton.extended(
                                    heroTag: "TryBtn",
                                    label: Text(
                                      "TRY AGAIN",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'BuxtonSketch',
                                        fontSize: 25,
                                      ),
                                    ),
                                    backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                    onPressed: () {
                                      setState(() => wrong = false);
                                      _speak("Try Speaking $alphabet");
                                    }),
                                FloatingActionButton.extended(
                                    heroTag: "WrongNextBtn",
                                    label: Text(
                                      " NEXT",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'BuxtonSketch',
                                        fontSize: 25,
                                      ),
                                    ),
                                    backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                    onPressed: () {
                                      if (number < 27) {
                                        setState(() => number = number + 1);
                                        setState(() => alphabet = alphabets[number]);
                                        setState(
                                                () => points_earned += points_arr[number]);
                                        callPointsEarned();
                                        print("Points earned" +
                                            points_earned.toString() +
                                            " - " +
                                            points_arr[number].toString());

                                        setState(() => wrong = false);
                                        _speak("Try Speaking $alphabet");
                                      } // if
                                      else {
                                        setState(() => wrong = false);
                                        setState(() => finish = true);
                                      }
                                    } // onpressed
                                ),
                          ])
                    ],
                  ),
                ],
              ),
            ),
            Container(
                  width: finish ? double.infinity : 0,
                  height: finish ? double.infinity : 0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/bg.jpeg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedContainer(
                        child: Image.asset(
                          "assets/trophy.gif",
                          height: 250,
                          width: 200,
                        ),
                        duration: Duration(seconds: 1000),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "CONGRATULATIONS",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'BuxtonSketch',
                              fontSize: 43,
                              color: Color.fromRGBO(0, 255, 0, 1),
                            ),
                          ),
                          Text(
                            "YOU HAVE COMPLETED ALL ALPHABETS",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'BuxtonSketch',
                              fontSize: 43,
                              color: Color.fromRGBO(0, 255, 0, 1),
                            ),
                          ),
                          FloatingActionButton.extended(
                              heroTag: "FinishBtn",
                              label: Text(
                                "TRY AGAIN",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'BuxtonSketch',
                                  fontSize: 25,
                                ),
                              ),
                              backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                              onPressed: () {
                                setState(() => number = 1);
                                setState(() => finish = false);
                                _speak("Try Speaking $alphabet");
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
          ])),
    );
  }


  void _listen(String alphabet) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(
                "you have to speak ${pronun[alphabet][0]}, ${pronun[alphabet][1]}, ${pronun[alphabet][2]}");
            print(number);
            print(alphabet);

            if (alphabet == "C" || alphabet == "E" || alphabet == "P") {
              setState(() => correct = true);
              _speak("Correct well done");
              setState(() => _text = "");
              setState(() => _isListening = false);
              setState(() => alphabet = alphabets[number]);
              if(_isListening){
                setState(() => points_earned += points_arr[number]);
                callPointsEarned();
                print("Points earned" +
                    points_earned.toString() +
                    " - " +
                    points_arr[number].toString());
              }
            }
            if (!(_text == "")) {
              if (_text == pronun[alphabet][0] ||
                  _text == pronun[alphabet][1] ||
                  _text == pronun[alphabet][2]) {
                print("correct");
                print("you spoke $_text");
                setState(() => correct = true);
                setState(() => _text = "");
                if(_isListening){
                  setState(() => points_earned += points_arr[number]);
                  callPointsEarned();
                  print("Points earned" +
                      points_earned.toString() +
                      " - " +
                      points_arr[number].toString());
                }
                _speak("Correct well done");
                setState(() => _isListening = false);
              } else {
                print("wrong");
                print("you spoke $_text");
                setState(() => wrong = true);
                setState(() => number = number);
                setState(() => _text = "");
                _speak("oh please try again");
                setState(() => _isListening = false);
              }
            }

            if (_speech.isNotListening) {
              setState(() => _isListening = false);
              setState(() => _text = "");

              _speech.stop();
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void callPointsEarned() {
    prefs.setInt("POINTS", points_earned);
  }
}

class TwoPageRoute extends CupertinoPageRoute {
  TwoPageRoute() : super(builder: (BuildContext context) => new TwoPage());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new TwoPage());
  }
}

class TwoPage extends StatefulWidget {
  @override
  _TwoPageState createState() => new _TwoPageState();
}

class _TwoPageState extends State<TwoPage> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  Random random;
  String _text = '';

  // ignore: non_constant_identifier_names

  int number = 7;
  int points = 40;
  int points_earned = 0;
  Map<int, String> alphabets = {
    1: "am",
    2: "an",
    3: "as",
    4: "at",
    5: "by",
    6: "do",
    7: "go",
    8: "he",
    9: "hi",
    10: "if",
    11: "in",
    12: "is",
    13: "it",
    14: "me",
    15: "no",
    16: "of",
    17: "or",
    18: "on",
    19: "so",
    20: "to",
    21: "le",
    22: "up",
    23: "we",
    24: "pa",
    25: "ko",
    26: "om",
    27: "da",
    28: "ki",
    29: "mo",
    30: "ma",
    31: "la",
    32: "ta",
    33: "li",
    34: "pi",
    35: "na",
    36: "ho",
  };

  Map<String, List> pronun = {
    "am": ["am", "am", 'uyfi'],
    "an": ["an", 'and', 'n'],
    "as": ["as", 's', 'uigiu'],
    "at": ["at", 'ad', 'biugkbj'],
    "by": ["by", "bye", 'khgkuh'],
    "do": ["do", 'jugih', 'kgiukg'],
    "go": ["go", 'jhfiukgv', 'kgkiug'],
    "he": ["he", "hi", 'igkui'],
    "hi": ["hi", "hai", 'ygiugu'],
    "if": ["if", "hihiiug", 'uyfi'],
    "in": ["in" "hihiiug", 'uyfi'],
    "is": ["is" "hihiiug", 'uyfi'],
    "it": ["it" "hihiiug", 'uyfi'],
    "me": ["me", "MI", 'jugih'],
    "no": ["no" "hihiiug", 'uyfi'],
    "of": ["of" "hihiiug", 'uyfi'],
    "or": ["or", "are", 'jugih'],
    "on": ["on" "hihiiug", 'uyfi'],
    "so": ["so" "hihiiug", 'uyfi'],
    "to": ["to", "Tu", 'two'],
    "le": ["le" "hihiiug", 'uyfi'],
    "up": ["up" "hihiiug", 'uyfi'],
    "we": ["we", "v", "V"],
    "pe": ["pe", "pay", 'jugih'],
    "ko": ["ko" "hihiiug", 'uyfi'],
    "om": ["om", "home", "Om"],
    "da": ["da", "the", 'jugih'],
    "ki": ["ki", "key", 'jugih'],
    "mo": ["mo", "more", 'jugih'],
    "ma": ["ma", "maa", 'jugih'],
    "la": ["la", "LA", 'jugih'],
    "ta": ["ta", "ta", 'jugih'],
    "li": ["li", "Lee", 'jugih'],
    "pi": ["pi", "p", "Pi"],
    "na": ["na" "hihiiug", 'uyfi'],
    "ho": ["ho", "Ho", 'jugih'],
  };
  SharedPreferences prefs;
  bool correct = false;
  bool wrong = false;
  int level=0;
  List<int> levels=[750,2000,5000,10000];

  final FlutterTts flutterTts = FlutterTts();
  Future _speak(text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(.85);
    await flutterTts.setPitch(.85);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    _speak("try speaking go");
    _speech = stt.SpeechToText();
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {


      points_earned = prefs.getInt("POINTS") ?? 0;
      if(points_earned<levels[0]){
        level=0;
      }
      else if(points_earned<levels[1]){
        level=1;
      }
      else if(points_earned<levels[2]){
        level=2;
      }
      else if(points_earned<levels[3]){
        level=3;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    String alphabet = alphabets[number];
    return SafeArea(
      child: Scaffold(
          body: Stack(children: <Widget>[
            Container(
              margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 25.0,
                animationDuration: 9000,
                percent: level>0?(points_earned-levels[level-1])/levels[level]:points_earned/levels[level],
                center: Text((level>0?(points_earned-levels[level-1]):points_earned).toString()),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.lightGreen,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    level>0?Text("Level "+(level).toString()+ "("+levels[level-1].toString()+")"):Container(),
                    Text("Level "+(level+1).toString() + "("+levels[level].toString()+")"),
                  ],
                ),
              ),
            ),

            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    child: Image.asset("assets/try.gif"),
                    duration: Duration(seconds: 1000),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        ' try speaking : $alphabet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'BuxtonSketch',
                          fontSize: 45,
                          color: Color.fromRGBO(133, 51, 255, 1),
                        ),
                      ),
                      AvatarGlow(
                        animate: _isListening,
                        glowColor: Color.fromRGBO(133, 51, 255, 1),
                        endRadius: 75.0,
                        duration: const Duration(milliseconds: 2000),
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        repeat: true,
                        child: FloatingActionButton(
                          heroTag: "RandomListen",
                          backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                          onPressed: () => _listen(alphabet),
                          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                width: correct ? double.infinity : 0,
                height: correct ? double.infinity : 0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bg.jpeg"),
                    fit: BoxFit.fill,
                  ),
                ),
                child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                        child: LinearPercentIndicator(
                          animation: true,
                          lineHeight: 25.0,
                          animationDuration: 9000,
                          percent: level>0?(points_earned-levels[level-1])/levels[level]:points_earned/levels[level],
                          center: Text((level>0?(points_earned-levels[level-1]):points_earned).toString()),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.lightGreen,
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Level "+(level).toString()+ "("+levels[level].toString()+")"),
                              Text("Level "+(level+1).toString() + "("+levels[level+1].toString()+")"),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/cake.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/correct.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/star.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "CORRECT WELL DONE",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'BuxtonSketch',
                                  fontSize: 23,
                                  color: Color.fromRGBO(0, 255, 0, 1),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    FloatingActionButton.extended(
                                        heroTag: "BackBtn",
                                        label: Text(
                                          "BACK",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'BuxtonSketch',
                                            fontSize: 25,
                                          ),
                                        ),
                                        backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                        onPressed: () {
                                          setState(() => correct = false);
                                          _speak("Try Speaking $alphabet");
                                        }),
                                    FloatingActionButton.extended(
                                        heroTag: "NextBtn",
                                        label: Text(
                                          "NEXT",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'BuxtonSketch',
                                            fontSize: 25,
                                          ),
                                        ),
                                        backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                        onPressed: () {
                                          setState(
                                                  () => number = new Random().nextInt(36) + 1);
                                          setState(() => alphabet = alphabets[number]);

                                          setState(() => correct = false);
                                          _speak("Try Speaking $alphabet");
                                        }),
                                  ])
                            ],
                          ),
                        ],
                      ),
                    ])),
            /*Container(
              width: correct ? double.infinity : 0,
              height: correct ? double.infinity : 0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/celebration.gif"),
                  fit: BoxFit.fill,
                ),
              ),
            ),*/
            Container(
              width: wrong ? double.infinity : 0,
              height: wrong ? double.infinity : 0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    child: Image.asset(
                      "assets/sorry.gif",
                      height: 250,
                      width: 200,
                    ),
                    duration: Duration(seconds: 1000),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "OHH PLEASE TRY AGAIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'BuxtonSketch',
                          fontSize: 43,
                          color: Color.fromRGBO(0, 255, 0, 1),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton.extended(
                                heroTag: "TryBtn",
                                label: Text(
                                  "TRY AGAIN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'BuxtonSketch',
                                    fontSize: 25,
                                  ),
                                ),
                                backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                onPressed: () {
                                  setState(() => wrong = false);
                                  _speak("Try Speaking $alphabet");
                                }),
                            FloatingActionButton.extended(
                                heroTag: "WrongNextBtn",
                                label: Text(
                                  " NEXT",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'BuxtonSketch',
                                    fontSize: 25,
                                  ),
                                ),
                                backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                onPressed: () {
                                  setState(() => wrong = false);

                                  setState(
                                          () => number = new Random().nextInt(36) + 1);
                                  setState(() => alphabet = alphabets[number]);

                                  _speak("Try Speaking $alphabet");
                                }),
                          ])
                    ],
                  ),
                ],
              ),
            ),
          ])),
    );
  }

  void _listen(String alphabet) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);

        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(
                "you have to speak ${pronun[alphabet][0]}, ${pronun[alphabet][1]}, ${pronun[alphabet][2]}");
            print(number);

            if (!(_text == "")) {
              if (_text == pronun[alphabet][0] ||
                  _text == pronun[alphabet][1] ||
                  _text == pronun[alphabet][2]) {
                print("correct");
                print("you spoke $_text");
                setState(() => correct = true);
                setState(() => _text = "");
                if(_isListening){
                  setState(() => points_earned += points);
                  callPointsEarned();
                  print("Points earned" +
                      points_earned.toString() +
                      " - " +
                      points.toString());
                }
                _speak("Correct well done");
                setState(() => _isListening = false);
              } else {
                print("wrong");
                print("you spoke $_text");
                setState(() => wrong = true);
                setState(() => number = number);
                setState(() => _text = "");
                _speak("oh please try again");
                setState(() => _isListening = false);
              }
            }

            if (_speech.isNotListening) {
              setState(() => _isListening = false);
              setState(() => _text = "");

              _speech.stop();
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void callPointsEarned() {
    prefs.setInt("POINTS", points_earned);
  }
}

class ThreePageRoute extends CupertinoPageRoute {
  ThreePageRoute() : super(builder: (BuildContext context) => new ThreePage());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new ThreePage());
  }
}

class ThreePage extends StatefulWidget {
  @override
  _ThreePageState createState() => new _ThreePageState();
}

class _ThreePageState extends State<ThreePage> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  Random random;
  String _text = '';

  // ignore: non_constant_identifier_names

  int number = 7;
  int points = 60;
  int points_earned = 0;
  Map<int, String> alphabets = {
    1: 'ant',
    2: 'are',
    3: 'bug',
    4: 'bat',
    5: 'pig',
    6: 'pen',
    7: 'one',
    8: 'box',
    9: 'fan',
    10: 'car',
    11: 'jet',
    12: 'pan',
    13: 'dot',
    14: 'hen',
    15: 'bed',
    16: 'cap',
    17: 'red',
    18: 'fox',
    19: 'cat',
    20: 'hat',
    21: 'cry',
    22: 'tip',
    23: 'hub',
    24: 'ran',
    25: 'his',
    26: 'son',
    27: 'dam',
    28: 'lot',
    29: 'toy',
    30: 'tin',
    31: 'not',
    32: 'den',
    33: 'log',
    34: 'day',
    35: 'pad',
    36: 'hit',
  };

  Map<String, List> pronun = {
    'ant': ['ant', "and", 'uyfi'],
    'are': ['are', 'hihuh', 'iugu'],
    'bug': ['bug', 'Bagh', 'bag'],
    'bat': ['bat', 'jgiuhu', 'biugkbj'],
    'pig': ['pig', "bdweye", 'khgkuh'],
    'pen': ['pen', 'jugih', 'kgiukg'],
    'one': ['one', '1', 'kgkiug'],
    'box': ['box', "hefi", 'igkui'],
    'fan': ['fan', "hfewfai", 'ygiugu'],
    'car': ['car', "ka", 'uyfi'],
    'jet': ['jet' "hihiiug", 'uyfi'],
    'pan': ['pan' "hihiiug", 'uyfi'],
    'dot': ['dot' "hihiiug", 'uyfi'],
    'hen': ['hen', "MefwfI", 'jugih'],
    'bed': ['bed' "hihiiug", 'uyfi'],
    'cap': ['cap' "hihiiug", 'uyfi'],
    'red': ['red', "arfefe", 'jugih'],
    'fox': ['fox' "hihiiug", 'uyfi'],
    'cat': ['cat' "hihiiug", 'uyfi'],
    'hat': ['hat', "Tuewf", 'jugih'],
    'cry': ['cry' "hihiiug", 'uyfi'],
    'tip': ['tip' "hihiiug", 'uyfi'],
    'hub': ['hub', "vewf", "Vfewf"],
    'ran': ['ran', "pafewy", 'juegih'],
    'his': ['his' "hihiiug", 'uyfi'],
    'son': ['son', "hoefwme", "Oewfm"],
    'dam': ['dam', "Dam", 'jugih'],
    'lot': ['lot', "kfewey", 'jugih'],
    'toy': ['toy', "mofewre", 'jugih'],
    'tin': ['tin', "mefwaa", 'jugih'],
    'not': ['not', "LefwA", 'jugih'],
    'den': ['den', "tafew", 'jugih'],
    'log': ['log', "Leeew", 'jugih'],
    'day': ['day', "pfew", "pefewa"],
    'pad': ['pad', "hihiiug", 'uyfi'],
    'hit': ['hit', "Hfewo", 'jugih'],
  };
  SharedPreferences prefs;
  bool correct = false;
  bool wrong = false;
  int level=0;
  List<int> levels=[750,2000,5000,10000];

  final FlutterTts flutterTts = FlutterTts();
  Future _speak(text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(.85);
    await flutterTts.setPitch(.85);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();
    _speak("try speaking one");
    _speech = stt.SpeechToText();
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {


      points_earned = prefs.getInt("POINTS") ?? 0;
      if(points_earned<levels[0]){
        level=0;
      }
      else if(points_earned<levels[1]){
        level=1;
      }
      else if(points_earned<levels[2]){
        level=2;
      }
      else if(points_earned<levels[3]){
        level=3;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    String alphabet = alphabets[number];
    return SafeArea(
      child: Scaffold(
          body: Stack(children: <Widget>[
            Container(
              margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 25.0,
                animationDuration: 9000,
                percent: level>0?(points_earned-levels[level-1])/levels[level]:points_earned/levels[level],
                center: Text((level>0?(points_earned-levels[level-1]):points_earned).toString()),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.lightGreen,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("Level "+(level).toString()+ "("+levels[level].toString()+")"),
                    Text("Level "+(level+1).toString() + "("+levels[level+1].toString()+")"),
                  ],
                ),
              ),
            ),

            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    child: Image.asset("assets/try.gif"),
                    duration: Duration(seconds: 1000),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        ' try speaking : $alphabet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'BuxtonSketch',
                          fontSize: 65,
                          color: Color.fromRGBO(133, 51, 255, 1),
                        ),
                      ),
                      AvatarGlow(
                        animate: _isListening,
                        glowColor: Color.fromRGBO(133, 51, 255, 1),
                        endRadius: 75.0,
                        duration: const Duration(milliseconds: 2000),
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        repeat: true,
                        child: FloatingActionButton(
                          heroTag: "RandomListen",
                          backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                          onPressed: () => _listen(alphabet),
                          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                width: correct ? double.infinity : 0,
                height: correct ? double.infinity : 0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bg.jpeg"),
                    fit: BoxFit.fill,
                  ),
                ),
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                        child: LinearPercentIndicator(
                          animation: true,
                          lineHeight: 25.0,
                          animationDuration: 9000,
                          percent: level>0?(points_earned-levels[level-1])/levels[level]:points_earned/levels[level],
                          center: Text((level>0?(points_earned-levels[level-1]):points_earned).toString()),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.lightGreen,
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(left:MediaQuery.of(context).size.width*.2,right:MediaQuery.of(context).size.width*.2 ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Level "+(level).toString()+ "("+levels[level].toString()+")"),
                              Text("Level "+(level+1).toString() + "("+levels[level+1].toString()+")"),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/cake.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/correct.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                              AnimatedContainer(
                                child: Image.asset(
                                  "assets/star.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                duration: Duration(seconds: 1000),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "CORRECT WELL DONE",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'BuxtonSketch',
                                  fontSize: 23,
                                  color: Color.fromRGBO(0, 255, 0, 1),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    FloatingActionButton.extended(
                                        heroTag: "BackBtn",
                                        label: Text(
                                          "BACK",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'BuxtonSketch',
                                            fontSize: 25,
                                          ),
                                        ),
                                        backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                        onPressed: () {
                                          setState(() => correct = false);
                                          _speak("Try Speaking $alphabet");
                                        }),
                                    FloatingActionButton.extended(
                                        heroTag: "NextBtn",
                                        label: Text(
                                          "NEXT",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'BuxtonSketch',
                                            fontSize: 25,
                                          ),
                                        ),
                                        backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                        onPressed: () {
                                          setState(
                                                  () => number = new Random().nextInt(36) + 1);
                                          setState(() => alphabet = alphabets[number]);

                                          setState(() => correct = false);
                                          _speak("Try Speaking $alphabet");
                                        }),
                                  ])
                            ],
                          ),
                        ],
                      ),
                    ])),
            Container(
              width: wrong ? double.infinity : 0,
              height: wrong ? double.infinity : 0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/bg.jpeg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    child: Image.asset(
                      "assets/sorry.gif",
                      height: 250,
                      width: 200,
                    ),
                    duration: Duration(seconds: 1000),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "OHH PLEASE TRY AGAIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'BuxtonSketch',
                          fontSize: 43,
                          color: Color.fromRGBO(0, 255, 0, 1),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton.extended(
                                heroTag: "TryBtn",
                                label: Text(
                                  "TRY AGAIN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'BuxtonSketch',
                                    fontSize: 25,
                                  ),
                                ),
                                backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                onPressed: () {
                                  setState(() => wrong = false);
                                  _speak("Try Speaking $alphabet");
                                }),
                            FloatingActionButton.extended(
                                heroTag: "WrongNextBtn",
                                label: Text(
                                  " NEXT",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'BuxtonSketch',
                                    fontSize: 25,
                                  ),
                                ),
                                backgroundColor: Color.fromRGBO(92, 0, 230, 1),
                                onPressed: () {
                                  setState(() => wrong = false);

                                  setState(
                                          () => number = new Random().nextInt(36) + 1);
                                  setState(() => alphabet = alphabets[number]);

                                  _speak("Try Speaking $alphabet");
                                }),
                          ])
                    ],
                  ),
                ],
              ),
            ),
          ])),
    );
  }

  void _listen(String alphabet) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);

        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(
                "you have to speak ${pronun[alphabet][0]}, ${pronun[alphabet][1]}, ${pronun[alphabet][2]}");
            print(number);

            if (!(_text == "")) {
              if (_text == pronun[alphabet][0] ||
                  _text == pronun[alphabet][1] ||
                  _text == pronun[alphabet][2]) {
                print("correct");
                print("you spoke $_text");
                setState(() => correct = true);
                setState(() => _text = "");
                if(_isListening){
                  setState(() => points_earned += points);
                  callPointsEarned();
                  print("Points earned" +
                      points_earned.toString() +
                      " - " +
                      points.toString());
                }
                _speak("Correct well done");
                setState(() => _isListening = false);
              } else {
                print("wrong");
                print("you spoke $_text");
                setState(() => wrong = true);
                setState(() => number = number);
                setState(() => _text = "");
                _speak("oh please try again");
                setState(() => _isListening = false);
              }
            }

            if (_speech.isNotListening) {
              setState(() => _isListening = false);
              setState(() => _text = "");

              _speech.stop();
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void callPointsEarned() {
    prefs.setInt("POINTS", points_earned);
  }
}
