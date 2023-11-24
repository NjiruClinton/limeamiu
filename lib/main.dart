import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lime/Controllers/units.dart';
import 'package:lime/firebase_options.dart';
import 'package:lime/pages/homepage/home.dart';
import 'package:lime/pages/sign_in.dart';

import 'Controllers/controllers.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Units.context = context;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfff9f9f9),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  Controllers.user != null ?
          const Home() : SignIn(),


    );
  }
}

