import 'package:flutter/material.dart';

class FinalPage extends StatelessWidget {
  final int score;
  final String totalTime;

  FinalPage({required this.score, required this.totalTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Finished',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Your Score: $score',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Total Time: $totalTime seconds',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
