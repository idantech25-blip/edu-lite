import 'package:ann/main_screen.dart';
import 'package:flutter/material.dart';
class GradingResultScreen extends StatefulWidget {
  final List<Map<String, dynamic>> result;

  const GradingResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  State<GradingResultScreen> createState() => _GradingResultScreenState();
}

class _GradingResultScreenState extends State<GradingResultScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final bgColor = isDark ? Colors.black : Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grading Results'),
        centerTitle: true,
        backgroundColor: bgColor,
        foregroundColor: textColor,
        elevation: 1,
      ),
      backgroundColor: bgColor,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.result.length,
        itemBuilder: (context, studentIndex) {
          final studentResult = widget.result[studentIndex];
          final int total = studentResult['total'] ?? 0;
          final String? studentName = studentResult['name'] as String?;
          final List<dynamic> details = studentResult['details'] ?? [];
          final DateTime gradedAt =
              DateTime.tryParse(studentResult['gradedAt'] ?? '') ??
              DateTime.now();

          // Recalculate score
          final int score =
              details.where((entry) => entry['isCorrect'] == true).length;
          widget.result[studentIndex]['score'] = score;

          return Card(
            color: cardColor,
            margin: const EdgeInsets.only(bottom: 24),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentName != null && studentName.isNotEmpty
                        ? 'Student: $studentName'
                        : 'Student ${studentIndex + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Score: $score / $total',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  Text(
                    'Graded at: ${gradedAt.toLocal().toString().split('.').first}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Question Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: details.length,
                    itemBuilder: (_, index) {
                      final Map<String, dynamic> entry = details[index];
                      final int qNum = entry['question'] ?? (index + 1);
                      final String studentAns = entry['studentAnswer'] ?? '';
                      final String correctAns = entry['correctAnswer'] ?? '';
                      final bool isCorrect = entry['isCorrect'] ?? false;
                      final String reason = entry['reason'] ?? '';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                          title: Row(
                            children: [
                              Expanded(child: Text('Q$qNum: $studentAns')),
                              if (entry.containsKey('originalAnswer') &&
                                  entry['originalAnswer'] != entry['studentAnswer'])
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Chip(
                                    label: Text('Edited', style: TextStyle(fontSize: 10)),
                                    backgroundColor: Colors.greenAccent,
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Correct: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: correctAns),
                                if (reason.isNotEmpty) ...[
                                  const TextSpan(
                                    text: '\nReason: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: reason),
                                ],
                              ],
                            ),
                          ),
                          isThreeLine: reason.isNotEmpty,
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final newAnswer = await _showEditDialog(
                                context,
                                studentAns,
                              );
                              if (newAnswer != null) {
                                setState(() {
                                  if (newAnswer == '__RESET__' && entry.containsKey('originalAnswer')) {
                                    entry['studentAnswer'] = entry['originalAnswer'];
                                  } else if (newAnswer.trim().isNotEmpty) {
                                    entry['originalAnswer'] ??= entry['studentAnswer'];
                                    entry['studentAnswer'] = newAnswer.trim();
                                  }

                                  entry['isCorrect'] = entry['studentAnswer'].toLowerCase().trim() ==
                                      correctAns.toLowerCase().trim();
                                });
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            foregroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Back to Dashboard',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Future<String?> _showEditDialog(BuildContext context, String initialAnswer) {
    final controller = TextEditingController(text: initialAnswer);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;

    return showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: cardColor,
            title: Text('Edit Answer', style: TextStyle(color: textColor)),
            content: TextField(
              controller: controller,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Student Answer',
                labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor.withOpacity(0.4)),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: textColor)),
              ),
              if (controller.text != initialAnswer && initialAnswer != '')
                TextButton(
                  onPressed: () => Navigator.pop(context, '__RESET__'),
                  child: Text('Reset', style: TextStyle(color: textColor)),
                ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.white : Colors.white,
                ),
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }
}
