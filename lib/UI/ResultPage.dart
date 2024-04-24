import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultPage extends StatefulWidget {
  final String timeTaken;
  final String score;
  final String totalQns;

  const ResultPage({
    Key? key,
    required this.timeTaken,
    required this.score,
    required this.totalQns,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user') ?? 'Guest';
    });
  }

  // Calculate the score percentage
  double _calculateScorePercentage() {
    int score = int.parse(widget.score);
    int totalQns = int.parse(widget.totalQns);
    return (score / totalQns) * 100;
  }

  // Get feedback message based on percentage
  String _getFeedbackMessage(double percentage) {
    if (percentage >= 90) {
      return "Excellent work! You're almost a pro!";
    } else if (percentage >= 80) {
      return "Great job! Keep up the good work!";
    } else if (percentage >= 70) {
      return "Good effort! You can do even better!";
    } else if (percentage >= 60) {
      return "You did well, but there's room for improvement.";
    } else if (percentage >= 50) {
      return "Not bad, but try to aim higher next time.";
    } else {
      return "There's room for improvement. Keep trying!";
    }
  }

  // Get color based on percentage
  Color _getColorBasedOnPercentage(double percentage) {
    if (percentage >= 90) {
      return Colors.green;
    } else if (percentage >= 80) {
      return Colors.lightGreen;
    } else if (percentage >= 70) {
      return Colors.yellow;
    } else if (percentage >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int remainingSeconds = totalSeconds % 3600;
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    // Return a formatted string in the form "hh:mm:ss"
    return '$hours hr $minutes min $seconds sec';
  }
  @override
  Widget build(BuildContext context) {
    double scorePercentage = _calculateScorePercentage();
    String feedbackMessage = _getFeedbackMessage(scorePercentage);
    Color progressColor = _getColorBasedOnPercentage(scorePercentage);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Congratulations, $userName!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Time Taken: ${_formatTime(int.parse(widget.timeTaken))}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Score: ${widget.score} / ${widget.totalQns}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            // CircularProgressIndicator with percentage
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                      value: scorePercentage / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      strokeWidth: 10,
                    ),
                  ),
                  // Display the percentage inside the progress indicator
                  Text(
                    '${scorePercentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Display the feedback message
            Text(
              feedbackMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
