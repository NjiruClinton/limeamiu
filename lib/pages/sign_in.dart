import 'package:lime/components/my_button.dart';
import 'package:lime/components/my_textfield.dart';
import 'package:lime/pages/homepage/home.dart';
import 'package:lime/pages/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth.dart';
import '../main.dart';

class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // final User? user = FirebaseAuth.instance.currentUser;
  // @override
  // void initState() {
  //   super.initState();
  //   if(user != null){
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => Home()),
  //     );
  //   }
  // }

  String? errorMessage = '';

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Future<void> signUserIn() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        print(e.code);
        errorMessage = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == "" ? "" : 'Humm ? $errorMessage',
      style: const TextStyle(color: Colors.redAccent),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      await Auth().signInWithGoogle();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        print(e.code);
        errorMessage = e.message;
      });
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Enter your email to reset your password'),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                // send reset password email
                Auth().sendPasswordResetEmail(email: emailController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Home()),
      // );
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                "Welcome back you've been missed!",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              _errorMessage(),
              const SizedBox(
                height: 50,
              ),
              MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text("Forgot password?",
                          style: TextStyle(color: Colors.grey.shade600)),
                      onPressed: () {
                        //   a dialogue to send reset password for email
                        _showMyDialog();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              MyButton(onTap: signUserIn),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey.shade400,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Or Continue with",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey.shade400,
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      signInWithGoogle();
                    },
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey.shade200,
                        ),
                        child: Image.asset(
                          "assets/images/google.png",
                          height: 40,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUp()),
                        );
                      },
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      )),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
