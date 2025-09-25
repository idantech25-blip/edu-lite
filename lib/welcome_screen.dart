import 'package:ann/login.dart';
import 'package:ann/signup.dart';
import 'package:flutter/material.dart';
import 'package:ann/login_screen.dart';
import 'package:ann/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _welcomeOpacity;
  late Animation<Offset> _welcomeSlide;

  late Animation<double> _buttonsOpacity;
  late Animation<Offset> _buttonsSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _welcomeOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _welcomeSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _buttonsOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _buttonsSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black87, Colors.grey[900]!, Colors.black87]
                : [const Color(0xFFFFFFFF), const Color(0xD8FFFFFF), const Color(
                0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 380),

              // Animated Welcome Text
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _welcomeOpacity.value,
                    child: Transform.translate(
                      offset: _welcomeSlide.value * 100,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  "Welcome User",
                  style: TextStyle(
                    fontFamily: 'Roboto-VariableFont_wdth,wght',
                    fontSize: 50,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 50),

              // Animated Buttons
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _buttonsOpacity.value,
                    child: Transform.translate(
                      offset: _buttonsSlide.value * 100,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 140,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.grey[700] : const Color(0xFFE8E8E8),
                              foregroundColor: isDark ? Colors.white : Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(170),
                              ),
                            ),
                            child: const Text('Login', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 140,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignupScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.grey[700] : const Color(0xFFE8E8E8),
                              foregroundColor: isDark ? Colors.white : Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(170),
                              ),
                            ),
                            child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "───────────── OR ─────────────",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.grey[300] : Colors.grey[800],
                      ),
                    ),
    SizedBox(
    width: 320,
    height: 65,
    child: ElevatedButton(
    onPressed: () {
    // Handle Google Sign-In
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: isDark ? Colors.grey[700] : const Color(0xFFEAE8E8),
    foregroundColor: isDark ? Colors.white : Colors.black,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(35),
    side: BorderSide(
    color: isDark ? const Color(0xFF676767) : const Color(0x07070700),

    ),
    ),
    ),
    child: const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    SizedBox(width: 10),
    Text(
    'Continue with Google',
    style: TextStyle(fontSize: 22),
    ),
    ],
    ),
    ),
    ),


    const SizedBox(height: 40),
            ],
          ),
        ),
      ],
      ),),),);
  }
}
