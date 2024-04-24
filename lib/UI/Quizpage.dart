import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/UI/ResultPage.dart';

import '../Models/Quizmodel.dart';
import 'dart:math';
import 'package:flutter/material.dart';

import 'countdownui.dart';

class Quizpage extends StatefulWidget {
  final List<Task> quizQuestions;
  const Quizpage({super.key, required this.quizQuestions});

  @override
  State<Quizpage> createState() => _QuizpageState();
}

class _QuizpageState extends State<Quizpage> {
  List<Task> quizQuestions = [];
 late DateTime quizStartTime;
  DateTime? quizEndTime;
  @override
  void initState() {
    setState(() {
      quizQuestions = widget.quizQuestions;
    });
    _startTimer();
    //
     quizStartTime = DateTime.now();
    super.initState();
  }

  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  Color? answerColor;
  int score = 0;
  int timeout = 0;
  late Timer _timer;
  int _countdown = 45;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted)
        setState(() {
          if (_countdown > 0) {
            _countdown--;
          } else {
            _timer.cancel();
            timeout++;
            _nextQuestion();
          }
        });
    });
  }

  void _nextQuestion() {
    showCorrectAnswer = false;
    isQuestionAnswered = false;
    if (currentQuestionIndex < quizQuestions.length - 1) {
      _resetTimer();
      _startTime = DateTime.now();
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        answerColor = null;
      });
    } else {
      _timer.cancel();
       quizEndTime = DateTime.now();
      _timer.cancel();
      
      // Calculate total duration and print it
      
        Duration totalDuration = quizEndTime!.difference(quizStartTime);
        print('Total time duration: ${totalDuration.inSeconds} seconds');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResultPage(timeTaken:  "${totalDuration.inSeconds}",score: score.toString(),totalQns:quizQuestions.length.toString() ,)),
      );
    }
  }

  void _resetTimer() {
    _timer.cancel();
    _countdown = 45;
    _startTimer();
  }

  bool submit_visible = false;
  bool showCorrectAnswer = false;
  bool isBlinking = false;
  late int correctAnswerIndex;
  void checkAnswer(int selectedIndex) {
    isBlinking = false;
    //_timer.cancel();
    if (selectedIndex ==
        quizQuestions[currentQuestionIndex].correctAnswerIndex) {
      // Correct answer

      setState(() {
        isBlinking = false;
        selectedAnswerIndex = selectedIndex;
        answerColor = Color.fromRGBO(0, 113, 0, 1);
        correctAnswerIndex = selectedIndex;

        score++;
        _totalTime += Duration(
            seconds: DateTime.now()
                .difference(_startTime!)
                .inSeconds); // Add the time taken to answer this question to the total time
      });
    } else {
      // Wrong answer

      setState(() {
        selectedAnswerIndex = selectedIndex;
        answerColor = Color.fromRGBO(238, 34, 12, 1);
        showCorrectAnswer = true; // set a flag to show the correct answer
        isBlinking = true;

        // set a flag to indicate blinking has started
      });
      // Blink the correct answer index 5 times
      int count = 0;
      Timer.periodic(Duration(milliseconds: 500), (timer) {
        setState(() {
          showCorrectAnswer = !showCorrectAnswer;
          count++;
        });
        if (count == 8) {
          timer.cancel();

          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              showCorrectAnswer = false;
              isBlinking = false; // set a flag to indicate blinking has ended
              correctAnswerIndex =
                  quizQuestions[currentQuestionIndex].correctAnswerIndex;
              // _nextQuestion();
            });
            _totalTime += Duration(
                seconds: DateTime.now().difference(_startTime!).inSeconds);
          });
        }
      });
    }
  }

  Color? textAnswerColor;
  bool isTextAnswerCorrect = false;

  bool hasFieldBeenSubmitted = false;
  bool isTextFieldEditable = true;
  bool showErrorText = false;
  TextEditingController _writtentext = TextEditingController();
  DateTime _startTime = DateTime.now();
  Duration _totalTime = Duration.zero;
  bool isQuestionAnswered = false;
  @override
  Widget build(BuildContext context) {
    // final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    // final double fontSize = fontSizeProvider.fontSize;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Flutter Quiz',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Container(
            height: 72.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black87,
                          spreadRadius: .5,
                          blurRadius: 8,
                          offset: Offset(1.0, 3.0),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          minimumSize: Size(100, 40),
                          //minimumSize: Size(150, 50),
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          'QUIT',
                          style: TextStyle(
                            fontSize: 20, color: Colors.white,
                            // fontFamily: fontfam,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CountdownGauge(
                      countdown: double.parse(_countdown.toString()),
                      size: 50, // Adjust the size of the gauge as needed
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '$_countdown',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.lerp(
                            Colors.green,
                            Colors.red,
                            (1 - (_countdown / 45)).clamp(0.0, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        // maximumSize: Size(150, 50),
                        minimumSize: Size(100, 30),
                        backgroundColor:
                            isBlinking ? Colors.white : Colors.black,
                      ),
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,

                          //  fontFamily: fontfam,
                        ),
                      ),
                      onPressed: isBlinking
                          ? null
                          : () {
                              isQuestionAnswered = false;
                              showCorrectAnswer = false;
                              _nextQuestion();
                              isTextFieldEditable = true;
                              _writtentext.clear();
                            },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Center(
                          child: Text(
                            quizQuestions[currentQuestionIndex].taskName,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Center(
                          child: Text(
                            '${currentQuestionIndex + 1}/${quizQuestions.length}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Color.fromRGBO(20, 71, 104, 1),
                  ),
                  if (quizQuestions[currentQuestionIndex].question.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        quizQuestions[currentQuestionIndex].question,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  Column(
                    children: [
                      ...quizQuestions[currentQuestionIndex]
                          .options
                          //
                          .where(
                              (option) => option != null && option.isNotEmpty)
                          .map((option) {
                        int optionIndex = quizQuestions[currentQuestionIndex]
                            .options
                            .indexOf(option);
                        return GestureDetector(
                          onTap: () {
                            if (!isQuestionAnswered) {
                              checkAnswer(optionIndex);
                              isQuestionAnswered = true;
                            }
                            _timer.cancel();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                              color: selectedAnswerIndex == optionIndex
                                  ? answerColor
                                  : showCorrectAnswer &&
                                          optionIndex ==
                                              quizQuestions[
                                                      currentQuestionIndex]
                                                  .correctAnswerIndex
                                      ? Color.fromRGBO(1, 113, 0, 1)
                                      : Color.fromRGBO(255, 255, 255, 1),
                              border: Border.all(
                                color: showCorrectAnswer &&
                                        optionIndex ==
                                            quizQuestions[currentQuestionIndex]
                                                .correctAnswerIndex
                                    ? Color.fromRGBO(0, 113, 0, 1)
                                    : Color.fromRGBO(238, 34, 12, 1),
                                width: showCorrectAnswer &&
                                        optionIndex ==
                                            quizQuestions[currentQuestionIndex]
                                                .correctAnswerIndex
                                    ? 0.5
                                    : 0,
                              ),
                            ),
                            child: ListTile(
                              title: Center(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: selectedAnswerIndex == optionIndex
                                        ? Colors.white:showCorrectAnswer&&optionIndex ==
                                            quizQuestions[currentQuestionIndex]
                                                .correctAnswerIndex?Colors.white
                                        : Colors.black
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (quizQuestions[currentQuestionIndex].info.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        child: Center(
                            child: Text(
                          quizQuestions[currentQuestionIndex].info,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        )),
                      ),
                    ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ));
  }
}
