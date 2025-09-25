import 'package:flutter/material.dart';
import 'package:ann/student_page.dart';

class ClassesHandledPage extends StatefulWidget {
  const ClassesHandledPage({super.key});

  @override
  State<ClassesHandledPage> createState() => _ClassesHandledPageState();
}

class _ClassesHandledPageState extends State<ClassesHandledPage> {
  final List<Map<String, String>> classes = [
    {
      "class": "SS1A",
      "subject": "Mathematics",
      "schedule": "Mon & Wed • 9AM - 10AM",
      "students": "24"
    },
    {
      "class": "SS2B",
      "subject": "Computer Science",
      "schedule": "Tue & Thu • 11AM - 12PM",
      "students": "18"
    },
    {
      "class": "SS3C",
      "subject": "English Literature",
      "schedule": "Mon & Wed • 1PM - 2PM",
      "students": "30"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Classes"),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
      ),
      body: ListView.builder(
        itemCount: classes.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final classItem = classes[index];
          return Card(
            color: cardColor,
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child:Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: textColor,
              collapsedIconColor: textColor,
              textColor: textColor,
              collapsedTextColor: textColor,
              title: Text(
                "Class: ${classItem["class"]}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              subtitle: Text(
                "Subject: ${classItem["subject"]}",
                style: TextStyle(color: textColor?.withOpacity(0.8)),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Schedule: ${classItem["schedule"]}", style: TextStyle(color: textColor)),
                      const SizedBox(height: 8),
                      Text("Students Enrolled: ${classItem["students"]}", style: TextStyle(color: textColor)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentPage(
                                classFilter: classItem["class"],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : Colors.black,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                        ),
                        child: const Text("View Students"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }
}
