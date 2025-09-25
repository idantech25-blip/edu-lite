import 'package:flutter/material.dart';
import 'grading_engine.dart';
import 'grading_result_screen.dart';
import 'package:lottie/lottie.dart';
class GradingInProgressScreen extends StatefulWidget {
  /// List of answers for each student.
  final List<List<String>> studentAnswers;
  final List<String> teacherAnswers;
  final GradingMode mode;



  const GradingInProgressScreen({
    Key? key,
    required this.studentAnswers,
    required this.teacherAnswers,
    this.mode = GradingMode.textMatch,
  }) : super(key: key);

  @override
  _GradingInProgressScreenState createState() => _GradingInProgressScreenState();
}

class _GradingInProgressScreenState extends State<GradingInProgressScreen> {
  int _currentStudent = 0;
  int _currentQuestion = 0;
  final Map<int, List<bool>> _resultsByStudent = {};
  final List<Map<String, dynamic>> _allResults = [];
  @override
  void initState() {
    super.initState();
    // Initialize result lists
    for (int i = 0; i < widget.studentAnswers.length; i++) {
      _resultsByStudent[i] = List<bool>.filled(widget.teacherAnswers.length, false);
    }
    // Start grading
    _gradeNextStudent();
  }

  Future<void> _gradeNextStudent() async {
    if (_currentStudent >= widget.studentAnswers.length) {
      _navigateToResults();
      return;
    }

    final answers = widget.studentAnswers[_currentStudent];

    final result = await GradingEngine.compareAnswers(
      studentAnswers: answers,
      teacherAnswers: widget.teacherAnswers,
      mode: widget.mode,
      onStep: _onStep,
    );

    _allResults.add(result);

    setState(() {
      _currentStudent++;
      _currentQuestion = 0;
    });

    _gradeNextStudent();
  }


  void _onStep(int index, String studentAnswer, bool isCorrect) {
    setState(() {
      _resultsByStudent[_currentStudent]![index] = isCorrect;
      _currentQuestion = index;
    });
  }

  void _navigateToResults() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GradingResultScreen(result: _allResults),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Grading In Progress'),
            centerTitle: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            foregroundColor: isDark ? Colors.white : Colors.black,
            elevation: 1,
          ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student ${_currentStudent + 1} of ${widget.studentAnswers.length}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Question ${_currentQuestion + 1} of ${widget.teacherAnswers.length}',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: widget.teacherAnswers.length,
                itemBuilder: (_, idx) {
                  final bool correct = _resultsByStudent[_currentStudent]![idx]==true;
                  Widget icon;
                  if (idx < _currentQuestion) {
                    icon = Icon(
                      correct ? Icons.check_circle : Icons.cancel,
                      color: correct ? Colors.green : Colors.red,
                    );
                  } else if (idx == _currentQuestion) {
                    icon = SizedBox(
                      width: 40,
                      height: 40,
                      child: Lottie.asset('assets/fonts/Animation.json'),
                    );
                  } else {
                    icon = const Icon(Icons.radio_button_unchecked, color: Colors.grey);
                  }
                  return ListTile(
                    leading: icon,
                    title: Text(
                      'Q${idx + 1}: ${widget.teacherAnswers[idx]}',
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
