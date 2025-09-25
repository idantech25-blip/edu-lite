import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ann/script_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ann/preview_page.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class GradingScren extends StatefulWidget {
  const GradingScren({super.key});

  @override
  State<GradingScren> createState() => _GradingScrenState();
}

class _GradingScrenState extends State<GradingScren> {
  final _picker = ImagePicker();

  Future<void> _pickAndPreview(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 85);
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);

        final inputImage = InputImage.fromFile(imageFile);
        final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
        final recognizedText = await textRecognizer.processImage(inputImage);
        await textRecognizer.close();

        String? extractedName;

        for (final block in recognizedText.blocks) {
          for (final line in block.lines) {
            final text = line.text.toLowerCase();
            // Skip lines like "School Name", "Subject Name", etc.
            if (text.contains('name') && !text.contains('school') && !text.contains('subject')) {
              final match = RegExp(r'name[:\-]?\s*(.*)', caseSensitive: false).firstMatch(line.text);
              if (match != null) {
                extractedName = match.group(1)?.trim();
              } else {
                // fallback if regex fails
                final parts = line.text.split(RegExp(r'[:\-]'));
                extractedName = parts.length > 1 ? parts[1].trim() : line.text.trim();
              }
              break;
            }
          }
          if (extractedName != null) break;
        }


        if (extractedName == null && recognizedText.blocks.isNotEmpty) {
          final firstBlock = recognizedText.blocks.first;
          if (firstBlock.lines.isNotEmpty) {
            extractedName = firstBlock.lines.first.text.trim();
          }
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewPage(
              studentScripts: [
                ScriptData(image: imageFile, extractedName: extractedName),
              ],
            ),
          ),
        );
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundGradient = LinearGradient(
      colors: isDark
          ? [Color(0xFF1C1C1C), Color(0xFF1A1A1A), Color(0xFF121212)]
          : [Color(0xFFD3D3D3), Color(0xFFD3D3D3), Color(0xFFD3D3D3)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final buttonColor = isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE8E8E8);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Column(
          children: [
            const Spacer(flex: 2),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickAndPreview(ImageSource.camera),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(130, 60),
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Snap', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _pickAndPreview(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(130, 60),
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Upload', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),

            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
