class Task {
  String taskName;
  String question;
 List<String> options;
  int correctAnswerIndex; // Index of the correct answer (0-3)
  String info;

  Task({
    required this.taskName,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.info,
  });
}
