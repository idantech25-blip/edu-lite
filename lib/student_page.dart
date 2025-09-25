import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentPage extends StatefulWidget {
  final String? classFilter;

  const StudentPage({super.key, this.classFilter});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final List<Map<String, String>> students = [
    {"name": "Grace Okoro", "Reg No.": "STU001", "class": "SS1A"},
    {"name": "Daniel Musa", "Reg No.": "STU002", "class": "SS2B"},
    {"name": "Fatima Lawal", "Reg No.": "STU003", "class": "SS1C"},
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedClass = "All";
  final List<String> _classList = ["All"];

  void _addStudent(Map<String, String> newStudent) {
    bool exists = students.any((s) => s["Reg No."] == newStudent["Reg No."]);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A student with this Reg No. already exists"),
        ),
      );
      return;
    }

    setState(() {
      students.add(newStudent);

      final studentClass = newStudent["class"];
      if (studentClass != null && !_classList.contains(studentClass)) {
        _classList.add(studentClass);
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("${newStudent['name']} added")));
  }

  @override
  void initState() {
    super.initState();

    for (var student in students) {
      final studentClass = student["class"];
      if (studentClass != null && !_classList.contains(studentClass)) {
        _classList.add(studentClass);
      }
    }
    if (widget.classFilter != null && _classList.contains(widget.classFilter)) {
      _selectedClass = widget.classFilter!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents =
        students.where((student) {
          final name = (student["name"] ?? "").toLowerCase();
          final regNo = (student["Reg No."] ?? "").toLowerCase();
          final query = _searchQuery.toLowerCase();
          final studentClass = student["class"] ?? "";
          final matchesSearch = name.contains(query) || regNo.contains(query);
          final matchesClass =
              _selectedClass == "All" || studentClass == _selectedClass;
          return matchesSearch && matchesClass;
        }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Students"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search by name or Reg No.",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text("Filter by class: "),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: _selectedClass,
                        items:
                            _classList.map((cls) {
                              return DropdownMenuItem(
                                value: cls,
                                child: Text(cls),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedClass = value!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredStudents.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide.none
                  ),
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide.none,
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide.none,
                    ),
                    title: Text(student["name"]!),
                    subtitle: Text("Reg No.: ${student["Reg No."]}"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Class: ${student["class"]}"),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text("QR Code:"),
                                const SizedBox(width: 10),
                                QrImageView(
                                  data: student["Reg No."]!,
                                  version: QrVersions.auto,
                                  size: 80,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return AddStudentForm(onSubmit: _addStudent);
            },
          );
        },
        backgroundColor: Color(0xFF000000),
        child: const Icon(Icons.add, color: Color(0xFFFFFFFF)),
      ),
    );
  }
}

class AddStudentForm extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const AddStudentForm({super.key, required this.onSubmit});

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  final _nameController = TextEditingController();
  final _regNoController = TextEditingController();
  final _classController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit({
        "name": _nameController.text.trim(),
        "Reg No.": _regNoController.text.trim(),
        "class": _classController.text.trim(),
      });
      _nameController.clear();
      _regNoController.clear();
      _classController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add New Student",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
              validator:
                  (value) => value!.isEmpty ? "Enter the student's name" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _regNoController,
              decoration: const InputDecoration(labelText: "Reg No."),
              validator:
                  (value) =>
                      value!.isEmpty ? "Enter the registration number" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _classController,
              decoration: const InputDecoration(
                labelText: "Class (e.g., SS1A)",
              ),
              validator: (value) => value!.isEmpty ? "Enter the class" : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text(
                "Add Student",
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
