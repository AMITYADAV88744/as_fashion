
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Screen/MainScreen/MainScreenPage.dart';

void main() async{
 if(kIsWeb==true){
   print("1");
   WidgetsFlutterBinding.ensureInitialized();
   await  Firebase.initializeApp(
     //name: "AS Fashion",
     options: const FirebaseOptions(
       apiKey: "AIzaSyAHoqwH05Yr1LTtSNaSKw2VcGMzijqjtbc",
       authDomain: "as-fashion-cf556.firebaseapp.com",
       databaseURL: "https://as-fashion-cf556-default-rtdb.firebaseio.com",
       projectId: "as-fashion-cf556",
       storageBucket: "as-fashion-cf556.appspot.com",
       messagingSenderId: "76605639865",
       appId: "1:76605639865:web:2cccc4c3e124634e931f68",
       measurementId: "G-Z5KSXKVDHZ",
     ),
   );
   runApp(  const MyApp());

 }else{
   print("2");

   WidgetsFlutterBinding.ensureInitialized();
   await  Firebase.initializeApp(
    name: "AS Fashion",
     options: const FirebaseOptions(
       apiKey: "AIzaSyAHoqwH05Yr1LTtSNaSKw2VcGMzijqjtbc",
       authDomain: "as-fashion-cf556.firebaseapp.com",
       databaseURL: "https://as-fashion-cf556-default-rtdb.firebaseio.com",
       projectId: "as-fashion-cf556",
       storageBucket: "as-fashion-cf556.appspot.com",
       messagingSenderId: "76605639865",
       appId: "1:76605639865:web:2cccc4c3e124634e931f68",
       measurementId: "G-Z5KSXKVDHZ",
     ),
   );
   runApp(  const MyApp());

 }
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
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
          //primaryColorDark: Colors.yellowAccent[700],
        ),
      ),
      home: const Scaffold(
        body: SplashScreen(),
      )
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
            ()=>Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const MainScreenPage()))
    );
  }
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("------SplashScreen---");
    }
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
