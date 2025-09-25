import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ann/script_data.dart';
import 'grading_in_progress_screen.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScriptPreviewScreen extends StatefulWidget {
  final File teacherScript;
  final List<ScriptData> studentScripts;

  const ScriptPreviewScreen({
    super.key,
    required this.teacherScript,
    required this.studentScripts,
  });

  @override
  State<ScriptPreviewScreen> createState() => _ScriptPreviewScreenState();
}

class _ScriptPreviewScreenState extends State<ScriptPreviewScreen> {
  bool _isLoading = false;
  File? _teacherScript;
  final Map<int, List<String>> extractedAnswersMap = {};
  final Map<int, String?> studentNames = {};
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _teacherScript = widget.teacherScript;

    for (int i = 0; i < widget.studentScripts.length; i++) {
      final script = widget.studentScripts[i];
      final name = script.extractedName?.trim();
      studentNames[i] = (name != null && name.isNotEmpty) ? name : null;
      extractedAnswersMap[i] = []; // To be filled later
    }
  }

  Future<List<String>> extractAnswersFromImage(File scriptFile) async {
    final inputImage = InputImage.fromFile(scriptFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    List<String> extractedAnswers = [];

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        String text = line.text.trim();
        if (text.isNotEmpty) {
          extractedAnswers.add(text);
        }
      }
    }

    return extractedAnswers;
  }

  void _showImagePreview(File imageFile) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
        backgroundColor: Colors.black,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Image.file(imageFile, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  void _fillNameManually(int index) async {
    String? name = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempName = '';
        return AlertDialog(
          title: const Text('Enter Student Name'),
          content: TextField(
            onChanged: (value) => tempName = value,
            decoration: const InputDecoration(hintText: 'e.g. Emmanuel David'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, tempName),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (name != null && name.isNotEmpty) {
      setState(() {
        studentNames[index] = name;
      });
    }
  }

  void _snapNameAgain(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    String? detectedName;

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final text = line.text.toLowerCase();
        if (text.contains('name')) {
          final parts = line.text.split(RegExp(r'[:\-]'));
          detectedName = parts.length > 1 ? parts[1].trim() : line.text.trim();
          break;
        }
      }
      if (detectedName != null) break;
    }

    if (detectedName == null && recognizedText.blocks.isNotEmpty) {
      final firstBlock = recognizedText.blocks.first;
      if (firstBlock.lines.isNotEmpty) {
        detectedName = firstBlock.lines.first.text.trim();
      }
    }

    if (detectedName != null && detectedName.isNotEmpty) {
      setState(() {
        studentNames[index] = detectedName;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Detected name: $detectedName')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No name detected, try again.')));
    }
  }

  void _editTeacherScript(String action) async {
    final picker = ImagePicker();
    final picked =
    (action == 'camera')
        ? await picker.pickImage(source: ImageSource.camera)
        : (action == 'gallery')
        ? await picker.pickImage(source: ImageSource.gallery)
        : null;

    if (action == 'remove') {
      setState(() => _teacherScript = null);
    } else if (picked != null) {
      setState(() => _teacherScript = File(picked.path));
    }
  }

  Future<void> _continueToGrading() async {
    final allFilled = studentNames.values.every(
          (name) => name != null && name.trim().isNotEmpty,
    );
    if (!allFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fill in all student names before proceeding."),
        ),
      );
      return;
    }

    if (_teacherScript == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload the teacher’s script.")),
      );
      return;
    }

    final teacherAnswers = await extractAnswersFromImage(_teacherScript!);

    for (int i = 0; i < widget.studentScripts.length; i++) {
      final scriptFile = widget.studentScripts[i].image;
      extractedAnswersMap[i] = await extractAnswersFromImage(scriptFile);
    }

    final studentAnswers = List<List<String>>.generate(
      widget.studentScripts.length,
          (index) => extractedAnswersMap[index] ?? ['No Answer'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => GradingInProgressScreen(
          studentAnswers: studentAnswers,
          teacherAnswers: teacherAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Prepare for Grading'),
        centerTitle: true,
        elevation: 1,
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: textColor,
      ),
      body: Column(
        children: [
          // Teacher Script
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Answer Script',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black45, width: 3),
                  ),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_teacherScript != null &&
                              _teacherScript!.existsSync()) {
                            _showImagePreview(_teacherScript!);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 200,
                            width: double.infinity,
                            child:
                            _teacherScript != null &&
                                _teacherScript!.existsSync()
                                ? Image.file(
                              _teacherScript!,
                              fit: BoxFit.cover,
                            )
                                : Center(
                              child: Text(
                                'No Teacher Script',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: _editTeacherScript,
                          itemBuilder:
                              (_) => [
                            const PopupMenuItem(
                              value: 'camera',
                              child: Text('Retake Photo'),
                            ),
                            const PopupMenuItem(
                              value: 'gallery',
                              child: Text('Choose from Gallery'),
                            ),
                            const PopupMenuItem(
                              value: 'remove',
                              child: Text('Remove Script'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Student List Heading
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Student Scripts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          // Student List
          Expanded(
            child: ListView.separated(
              itemCount: widget.studentScripts.length,
              padding: const EdgeInsets.only(bottom: 100),
              separatorBuilder:
                  (_, __) => const Divider(thickness: 1, height: 24),
              itemBuilder: (context, index) {
                final scriptData = widget.studentScripts[index];
                final script = scriptData.image;
                final name = studentNames[index] ?? scriptData.extractedName;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : const Color(0xFFFDFDFD),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.blue.shade100, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _showImagePreview(script),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  script,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Student Name:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              name ?? 'Not detected',
                              style: TextStyle(
                                fontSize: 15,
                                color:
                                name == null ? Colors.redAccent : textColor,
                                fontStyle:
                                name == null
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _fillNameManually(index),
                                    icon: const Icon(Icons.edit, size: 18),
                                    label: const Text(
                                      'Fill',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      backgroundColor: Colors.black38,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _snapNameAgain(index),
                                    icon: const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 18,
                                    ),
                                    label: Text(
                                      'Snap',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      side: BorderSide(
                                        color:
                                        isDark
                                            ? Colors.white54
                                            : Colors.grey.shade400,
                                      ),
                                      foregroundColor:
                                      isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFFDAD3D3),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Continue Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: (_teacherScript == null)
                    ? null
                    : () async {
                  if (_isLoading) return;

                  setState(() => _isLoading = true);
                  await Future.delayed(const Duration(milliseconds: 300));
                  await _continueToGrading();
                  setState(() => _isLoading = false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_teacherScript == null)
                      ? Colors.grey
                      : Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  foregroundColor: (_teacherScript == null)
                      ? Colors.white70
                      : Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue to Grading',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

          ),
        ],
      ),
    );
  }
}
