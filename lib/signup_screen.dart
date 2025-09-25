import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Import SchedulerBinding
import 'login_screen.dart'; // Add the appropriate import for LoginScreen

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  bool _isObscured = true;
  bool _isChecked = false;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNodes = List.generate(3, (_) => FocusNode());

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    for (var focusNode in _focusNodes) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          _scrollToFocused(focusNode);
        }
      });
    }
  }

  void _scrollToFocused(FocusNode node) {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.pixels + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  String? _validatePassword(String password) {
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? (isDark ? Colors.white : Colors.black);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Color(0xff92d6e8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Color(0xff92d6e8),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.lightBlueAccent),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    "Create an Account",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: TextFormField(
                          controller: _emailController,
                          focusNode: _focusNodes[0],
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: textColor, fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            labelText: 'Enter Email',
                            hintText: 'Email',
                            hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                            labelStyle: TextStyle(color: textColor),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            suffixIcon: Icon(Icons.email, color: isDark ? Colors.white70 : Colors.black54),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: TextFormField(
                          focusNode: _focusNodes[1],
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            label: const Text('Enter ID'),
                            hintText: 'ID',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: const Icon(Icons.person),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscured,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            labelText: "Enter Password",
                            hintText: "Password",
                            hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                            labelStyle: TextStyle(color: textColor),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                              icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () => setState(() => _isLoading = true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?", style: TextStyle(color: Colors.black87, fontSize: 17)),
                            TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                              child: const Text('Login', style: TextStyle(fontSize: 17, color: Colors.blue)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "────────── OR ──────────",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white54 : Colors.grey[800]),
                      ),
                      const SizedBox(height: 20),
                      _buildSocialButton(context, icon: Icons.g_mobiledata_rounded, label: 'Continue with Google', backgroundColor: isDark ? Colors.grey[850]! : Colors.white, textColor: textColor),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Added bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, {required IconData icon, required String label, required Color backgroundColor, required Color textColor}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: textColor),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(fontSize: 16, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
