import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart'; // Replace this with your actual dashboard screen import

class WelcomeTourScreen extends StatefulWidget {
  final String displayName;

  const WelcomeTourScreen({super.key, required this.displayName});

  @override
  State<WelcomeTourScreen> createState() => _WelcomeTourScreenState();
}

class _WelcomeTourScreenState extends State<WelcomeTourScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Welcome to IDAN!",
      "desc": "Experience seamless access and top-notch features.",
    },
    {
      "title": "Stay Connected",
      "desc": "Get updates, tips, and support right when you need them.",
    },
    {
      "title": "Let's Get Started",
      "desc": "You're all set, time to dive into the full experience.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkIfTourCompleted();
  }

  void _checkIfTourCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isTourCompleted = prefs.getBool('isTourCompleted') ?? false;

    if (isTourCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()), // Replace with your actual dashboard screen
      );
    }
  }

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _completeTour();
    }
  }

  void _completeTour() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTourCompleted', true); // Mark tour as completed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScreen()), // Replace with your actual dashboard screen
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text("Hello, ${widget.displayName}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _pages[index]['title']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _pages[index]['desc']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.lightBlueAccent : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  _currentIndex == _pages.length - 1 ? "Get Started" : "Next",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
