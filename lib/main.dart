import 'dart:async';
import 'package:flutter/material.dart';
import 'package:paxa_todoapp/screens/login_screen.dart';
import 'package:shimmer/shimmer.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       height: double.infinity,
       width: double.infinity,
       decoration: const BoxDecoration(
        color: Color.fromARGB(255, 226, 226, 156)
        //  gradient: LinearGradient(
        //   tileMode: TileMode.mirror,
        //    colors: [
        //      Color.fromARGB(255, 248, 255, 150),
        //      Color.fromARGB(255, 255, 255, 255),
        //    ]
        //  )
       ), 
      child: Center(
        child: Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 0, 0, 0),
          highlightColor: const Color.fromARGB(255, 255, 255, 255),
          child: const Text(
            'Todo App ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    )
    );
  }
}

