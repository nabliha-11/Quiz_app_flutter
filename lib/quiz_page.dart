import 'package:flutter/material.dart';
import 'package:quiz_app/final_page.dart';
import 'package:quiz_app/question.dart';
import 'dart:async';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int score = 0;
  int questionIndex = 0;
  int lives=3;
  int totalTime=5;
  Timer?timer2;
  double progressValue=1.0;
  List<Question> questions = [
    Question(
      'What is the value of pi (π)?',
      '3.14159',
      ['3.14159', '2.71828', '1.61803', '4.66920'],
    ),
    Question(
      'Simplify the expression: 2 + 3 * 4 - 2',
      '12',
      ['8', '10', '12', '14'],
    ),
    Question(
      'What is the square root of 64?',
      '8',
      ['4', '6', '8', '10'],
    ),
    Question(
      'Solve for x: 2x + 5 = 15',
      '5',
      ['3', '5', '7', '9'],
    ),
    Question(
      'What is the value of 2^4?',
      '16',
      ['8', '12', '14', '16'],
    ),
  ];


  String? selectedOption;
  Timer? timer;
  late Stopwatch stopwatch;
  late String totalTimeSW;
  String elapsedTime='';
  int secondsRemaining = 5;

  @override
  void initState() {
    super.initState();
    startTimer1();
    startTimer2();
    stopwatch=Stopwatch();
    stopwatch.start();
  }

  void startTimer1() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (secondsRemaining < 1) {
          t.cancel();
          // Timer is complete, navigate to final page or perform any other actions
          moveToNext();
        } else {
          secondsRemaining--;
        }
      });
    });
  }
  void moveToNext()
  {
    resetTimer(); // Reset the timer for the next question
    questionIndex++;
    if (questionIndex == questions.length) {
      // All questions answered, navigate to the final page
      stopwatch.stop();
      navigateToFinalPage();
    }
    else{
      startTimer1();
    }
  }
  void startTimer2(){
    timer2 = Timer.periodic(Duration(seconds: 1), (timer2) {
      setState(() {
        if (totalTime > 0) {
          totalTime--;
          progressValue = totalTime / 5;
        } else {
          // Time runs out, reduce a life and check if the quiz should end
          lives--;
          if (lives <= 0) {
            // No more lives, end the quiz
            timer2.cancel();
            navigateToFinalPage();
          } else {
            // Reset the time for the next question
            totalTime = 5;
          }
        }
      });
    });
  }


  void answerQuestion(String? selectedOption) {
    if (selectedOption == questions[questionIndex].correctAnswer) {
      score += 10; // Increase the score for correct answers
    }
    setState(() {
      questions[questionIndex].selectedOption = selectedOption; // Assign the selected option to the current question
      questionIndex++;
      selectedOption = null; // Reset the selected option
      resetTimer(); // Reset the timer for the next question
    });
    if (questionIndex == questions.length) {
      // All questions answered, navigate to the final page
      stopwatch.stop();
      navigateToFinalPage();

    }
  }

  void resetTimer() {
    secondsRemaining =5 ;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void navigateToFinalPage() {
    timer2?.cancel();
    totalTimeSW = stopwatch.elapsed.inSeconds.toString();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FinalPage(score: score, totalTime:totalTimeSW),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final isLastQuestion = questionIndex == questions.length - 1;
    final buttonText = isLastQuestion ? 'Submit' : 'Next';

    return Scaffold(
        appBar: AppBar(
          title: Text('Quiz Page'),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            Text(
            'Question ${questionIndex + 1}/${questions.length}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              questions[questionIndex].questionText,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            ...questions[questionIndex].options
            .map(
        (option) => RadioListTile(
        title: Text(option),
    value: option,
    groupValue: questions[questionIndex].selectedOption,
    onChanged: (value) {
    setState(() {
    questions[questionIndex].selectedOption =value as String?;
    });
    },
        ),
            )
                .toList(),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (questions[questionIndex].selectedOption != null) {
                      answerQuestion(questions[questionIndex].selectedOption!);
                    }
                  },
                  child: Text(buttonText),
                ),
                SizedBox(height: 16),
                Text(
                  'Lives: $lives',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progressValue,
                ),
                Text(
                  'Time remaining: $secondsRemaining seconds',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ),
    );
  }
}

