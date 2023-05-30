class Question {
  final String questionText;
  final String correctAnswer;
  final List<String> options; // Define the options property
  String? selectedOption; // New property to track the selected option
  Question(this.questionText, this.correctAnswer, this.options);
}
