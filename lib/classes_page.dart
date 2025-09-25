import 'package:flutter/material.dart';
import 'classes_handled_page.dart';
import 'student_page.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Manage"),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.class_),
              label: const Text("Classes"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClassesHandledPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),

                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                foregroundColor: isDark ? Colors.white : Colors.black,
                elevation: 2,
              ),
            ),
            const SizedBox(height: 20, ),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text("Students"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StudentPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                foregroundColor: isDark ? Colors.white : Colors.black,
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
