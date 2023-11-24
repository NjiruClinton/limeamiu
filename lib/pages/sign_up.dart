import 'package:lime/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/my_textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? errorMessage = "";

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  final db = FirebaseFirestore.instance;

  Future<void> signupUser() async{
    try{
      await Auth().createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      // add username and email to firestore collection users
      await db.collection('users').add({
        'username': usernameController.text,
        'email': emailController.text,
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    } on FirebaseAuthException catch(e){
      if(e.code == 'weak-password'){
        setState(() {
          errorMessage = "The password provided is too weak.";
        });
      } else if(e.code == 'email-already-in-use'){
        setState(() {
          errorMessage = "The account already exists for that email.";
        });
      }
    } catch(e){
      print(e.toString());
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Widget _errorMessage(){
    return Text(errorMessage == "" ? "" : 'Humm $errorMessage', style: const TextStyle(color: Colors.redAccent),);
  }

  // void signUserUp() {
  //   print(usernameController.text);
  //   print(passwordController.text);
  // }

  Future<void> signInWithGoogle() async{
    try{
      await Auth().signInWithGoogle();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    } on FirebaseAuthException catch (e){
      setState(() {
        print(e.code);
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body:
      SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50,),
                  const Icon(Icons.lock, size: 100,),
                  const SizedBox(height: 50,),
                  Text("Welcome to Lime! Please sign up here.",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),),
                  const SizedBox(height: 50,),
                  _errorMessage(),
                  const SizedBox(height: 10,),
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10,),
                  MyTextField(
                    controller: usernameController,
                    hintText: "Username",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10,),
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10,),
                  MyTextField(
                    controller: passwordController2,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Forgot password?", style: TextStyle(color: Colors.grey.shade600),),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),
              GestureDetector(
                onTap: signupUser,
                child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        )
                    )
                ),
              ),
                  const SizedBox(height: 50,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey.shade400,
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("Or Continue with", style: TextStyle(color: Colors.grey.shade700),),
                        ),
                        Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey.shade400,
                            )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
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
                            child: Image.asset("assets/images/google.png",height: 40,)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a member?", style: TextStyle(color: Colors.grey.shade700),),
                      const SizedBox(width: 4,),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                            );
                          },

                          child: const Text("Login now", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)),
                    ],
                  )
                ],

              ),
            ),
          )
      ),
    );
  }
}
