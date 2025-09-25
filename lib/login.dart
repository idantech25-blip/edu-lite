import 'package:flutter/material.dart';
import 'package:ann/components/my_button.dart';
import 'package:ann/components/my_textfield.dart';
import 'package:ann/signup.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  void signUserIn(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                //logo
                const Icon(Icons.account_circle, size: 150),
                const SizedBox(height: 50),
                // Text
                Text(
                  'Welcome back (#)',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
                // username field
                MyTextfield(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                //password field
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                // forgot Password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                //Create Account
                    Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        "Don't have an account yet?", style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 4,),
                      TextButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_) => Signup())), 
                      child: const Text("Sign Up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                //sign up
                MyButton(
                  onTap: signUserIn,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
