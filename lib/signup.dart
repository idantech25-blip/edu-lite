import 'package:flutter/material.dart';
import 'package:ann/components/my_button2.dart';
import 'package:ann/components/my_textfield.dart';
import 'package:ann/login.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
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
                  'Welcome (#)',
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
                //confirm password field
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                //Sign In
                    Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        "Already have an account yet?", style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 4,),
                      TextButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_) => Login())), 
                      child: const Text("Log In", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                //sign up
                MyButton2(
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
