
import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screen/MainScreen/MainScreenPage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAunoBYWyh_Bta4_kq0KqiNLdxWKX8BHEo",
        authDomain: "as-fashion-1059d.firebaseapp.com",
        databaseURL: "https://as-fashion-1059d-default-rtdb.firebaseio.com",
        projectId: "as-fashion-1059d",
        storageBucket: "as-fashion-1059d.appspot.com",
        messagingSenderId: "785123700889",
        appId: "1:785123700889:web:06a43607b9d605be188808",
        measurementId: "G-DZ9B4J69RY"
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A.S Fashion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: SplashScreen(),
      ),
    );
  }

}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}
class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                const MainScreenPage()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    print("------SplashScreen---");
    return Container(
        color: Colors.black,
        child:Center(
          child: Image.asset(
            'assets/icon.png',
            height: 250,width: 250,
          ),
        )
    );
  }
}
