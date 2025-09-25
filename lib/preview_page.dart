import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ann/script_preview_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'script_data.dart';

class PreviewPage extends StatefulWidget {
  final List<ScriptData> studentScripts;
  const PreviewPage({super.key, required this.studentScripts});
  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  List<ScriptData> _scripts = [];
  void _viewImage(File image) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.black,
            insetPadding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: InteractiveViewer(child: Image.file(image)),
            ),
          ),
    );
  }

  void _confirmRemoveImage(int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Remove Image?"),
            content: Text("Are you sure you want to remove this image?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _scripts.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text("Remove", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scripts = List.from(widget.studentScripts);
  }

  Future<void> _addImageFromSource(ImageSource source) async {
    if (_scripts.length >= 10) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      File newImage = File(pickedFile.path);
      if (_scripts.any((script) => script.image.path == newImage.path)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This image is already added.")),
        );
        return;
      }
      String? extractedName = await extractNameFromImage(newImage);
      print('Extracted name: $extractedName');

      setState(() {
        _scripts.add(ScriptData(image: newImage, extractedName: extractedName));
      });
    }
  }

  Future<String?> extractNameFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      // Search for the line containing "Name" (case insensitive)
      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          final text = line.text.toLowerCase();
          if (text.contains('name')) {
            // Example: "Name: John Doe"
            final parts = line.text.split(RegExp(r'[:\-]')); // split on : or -
            if (parts.length > 1) {
              return parts[1].trim();
            } else {
              // if just "Name John Doe" no colon or dash
              return line.text.replaceAll(RegExp(r'(?i)name'), '').trim();
            }
          }
        }
      }
    } catch (e) {
      print('OCR failed: $e');
    }
    return null; // Return null if no name found
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        title: Text(
          "Preview Papers",
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        actions: [
          if (_scripts.length < 10)
            IconButton(
              icon: Icon(Icons.photo_library_sharp),
              onPressed: () => _addImageFromSource(ImageSource.gallery),
            ),
          IconButton(
            icon: Icon(Icons.camera_alt_rounded),
            onPressed: () => _addImageFromSource(ImageSource.camera),
          ),
        ],
      ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount:
                    _scripts.length < 10
                        ? _scripts.length + 1
                        : _scripts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  if (index == _scripts.length && _scripts.length < 10) {
                    // The "+" tile
                    return GestureDetector(
                      onTap: () => _addImageFromSource(ImageSource.gallery),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.grey[600]! : Colors.grey,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: 48,
                            color: isDark ? Colors.white : Colors.grey[800],
                          ),
                        ),
                      ),
                    );
                  }

                  // Normal image tile
                  final script = _scripts[index];

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GestureDetector(
                            onTap: () => _viewImage(script.image),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.file(
                                script.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (script.extractedName != null)
                        Positioned(
                          left: 4,
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              script.extractedName!,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.white,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          iconSize: 24,
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => _confirmRemoveImage(index),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed:
                    _scripts.isNotEmpty
                        ? () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile == null) return;

                          File teacherScript = File(pickedFile.path);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ScriptPreviewScreen(
                                    teacherScript: teacherScript,
                                    studentScripts: _scripts,
                                  ),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ), // increase vertical/horizontal padding slightly
                  minimumSize: const Size(
                    double.maxFinite,
                    60,
                  ),
                  foregroundColor: isDark ? Colors.white : Colors.black,
                  backgroundColor: isDark ? Colors.grey[900] : Colors.grey[200],
                ),
                child: Text("Proceed (${_scripts.length}/10)"),
              ),
            ),
            const SizedBox(height: 44),
          ],
        ),
    );
  }
}
