import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

enum GradingMode {
  textMatch,
  shading,
  tickCross,
  shaded,
  fillIn,
}

class GradingEngine {
  static final TextRecognizer textRecognizer = TextRecognizer();

  /// OCR review flag based on confidence
  static Future<List<int>> getLowConfidenceLines(InputImage inputImage) async {
    final recognizedText = await textRecognizer.processImage(inputImage);
    List<int> reviewLineIndices = [];

    int i = 0;
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        final confidence = line.confidence ?? 1.0;
        if (confidence < 0.7) {
          reviewLineIndices.add(i);
        }
        i++;
      }
    }

    return reviewLineIndices;
  }

  static Future<Map<String, dynamic>> compareAnswers({
    required List<String> studentAnswers,
    required List<String> teacherAnswers,
    GradingMode mode = GradingMode.textMatch,
    bool enableOcrCorrection = true,
    Function(int index, String studentAnswer, bool isCorrect)? onStep,
  }) async {
    int score = 0;
    List<Map<String, dynamic>> resultPerQuestion = [];

    for (int i = 0; i < studentAnswers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));

      String rawStudent = i < studentAnswers.length ? studentAnswers[i] : '';
      String rawTeacher = i < teacherAnswers.length ? teacherAnswers[i] : '';

      if (enableOcrCorrection) {
        rawStudent = correctOCR(rawStudent);
        rawTeacher = correctOCR(rawTeacher);
      }

      bool skipped = rawStudent.trim().isEmpty;
      bool needsReview = rawStudent.trim().length < 2; // Or use OCR confidence externally

      String student = clean(rawStudent);
      String teacher = clean(rawTeacher);

      bool correct = false;
      String reason = 'Unknown';
      String status = 'graded';

      if (skipped) {
        reason = 'Skipped by student';
        status = 'skipped';
      } else if (needsReview) {
        reason = 'Unclear answer — review needed';
        status = 'needsReview';
      } else {
        switch (mode) {
          case GradingMode.textMatch:
            correct = student == teacher;
            reason = correct ? 'Matched' : 'Did not match';
            break;
          case GradingMode.tickCross:
            correct = (student == '✔' && teacher == '✔') || (student == '✖' && teacher == '✖');
            reason = correct ? 'Tick/Cross matched' : 'Tick/Cross mismatch';
            break;
          case GradingMode.shaded:
            correct = student.toUpperCase() == teacher.toUpperCase();
            reason = correct ? 'Shaded option matched' : 'Wrong option selected';
            break;
          case GradingMode.shading:
            correct = student.toUpperCase() == teacher.toUpperCase();
            reason = correct ? 'Shading option matched' : 'Wrong option selected';
            break;
          case GradingMode.fillIn:
            correct = rawStudent.trim() == rawTeacher.trim();
            reason = correct ? 'Exact fill-in match' : 'Mismatch in fill-in answer';
            break;
        }
      }

      onStep?.call(i, rawStudent, correct);

      resultPerQuestion.add({
        'question': i + 1,
        'studentAnswer': rawStudent,
        'correctAnswer': rawTeacher.isNotEmpty ? rawTeacher : 'N/A',
        'isCorrect': correct,
        'status': status,
        'reason': reason,
      });

      if (correct) score++;
    }

    return {
      'score': score,
      'total': teacherAnswers.length,
      'details': resultPerQuestion,
      'gradedAt': DateTime.now().toIso8601String(),
    };
  }

  static String clean(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s✔✖A-Ea-e]'), '')
        .trim();
  }

  static String correctOCR(String input) {
    return input
        .replaceAll('0', 'O')
        .replaceAll('1', 'I')
        .replaceAll('l', 'I')
        .replaceAll('5', 'S')
        .replaceAll('8', 'B')
        .replaceAll('6', 'G')
        .replaceAll('¢', 'c')
        .replaceAll('√', '✔')
        .replaceAll('x', '✖')
        .replaceAll(RegExp(r'[^A-Za-z0-9\s✔✖]'), '');
  }
}
